"""Tiny animated-flow-diagram framework (PIL only).

Renders at 2x then downsamples, which gives clean antialiased edges without
needing cairo. Animation = black dots travelling along polyline edges, same
idea as the reference Jenkins/GitOps diagram.
"""
import math
from PIL import Image, ImageDraw, ImageFont

S = 2  # supersample factor

F = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
FB = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

INK = (30, 30, 30)
GREY = (120, 120, 120)
BLUE = (37, 99, 235)
TF_PURPLE = (94, 61, 224)
TF_PURPLE_D = (64, 40, 170)
AWS_ORANGE = (255, 153, 0)
S3_GREEN = (61, 141, 58)
DDB_BLUE = (52, 96, 189)
K8S_BLUE = (50, 108, 229)
DARK = (36, 41, 46)
RED = (200, 60, 60)
GREEN = (46, 139, 87)


def font(size, bold=False):
    return ImageFont.truetype(FB if bold else F, size * S)


class Canvas:
    def __init__(self, w, h, bg=(255, 255, 255)):
        self.w, self.h = w, h
        self.img = Image.new("RGB", (w * S, h * S), bg)
        self.d = ImageDraw.Draw(self.img)

    # ---- primitives (coords in logical px) ----
    def line(self, pts, fill=INK, width=1):
        self.d.line([(x * S, y * S) for x, y in pts], fill=fill, width=int(width * S),
                    joint="curve")

    def rect(self, box, outline=None, fill=None, width=1, radius=0):
        b = [box[0] * S, box[1] * S, box[2] * S, box[3] * S]
        if radius:
            self.d.rounded_rectangle(b, radius=radius * S, outline=outline, fill=fill,
                                     width=int(width * S))
        else:
            self.d.rectangle(b, outline=outline, fill=fill, width=int(width * S))

    def ellipse(self, box, outline=None, fill=None, width=1):
        self.d.ellipse([box[0] * S, box[1] * S, box[2] * S, box[3] * S],
                       outline=outline, fill=fill, width=int(width * S))

    def poly(self, pts, fill=None, outline=None, width=1):
        self.d.polygon([(x * S, y * S) for x, y in pts], fill=fill, outline=outline,
                       width=int(width * S))

    def dot(self, x, y, r, fill=INK, outline=None, ow=1):
        self.ellipse((x - r, y - r, x + r, y + r), fill=fill, outline=outline, width=ow)

    def text(self, x, y, s, size=11, bold=False, fill=INK, anchor="mm", spacing=3):
        self.d.multiline_text((x * S, y * S), s, font=font(size, bold), fill=fill,
                              anchor=anchor, align="center", spacing=spacing * S)

    def dashed(self, p0, p1, fill=GREY, width=1, dash=6, gap=4):
        (x0, y0), (x1, y1) = p0, p1
        dist = math.hypot(x1 - x0, y1 - y0)
        if dist == 0:
            return
        ux, uy = (x1 - x0) / dist, (y1 - y0) / dist
        t = 0.0
        while t < dist:
            e = min(t + dash, dist)
            self.line([(x0 + ux * t, y0 + uy * t), (x0 + ux * e, y0 + uy * e)],
                      fill=fill, width=width)
            t = e + gap

    def dashed_rect(self, box, fill=BLUE, width=1, dash=7, gap=5, radius=0):
        x0, y0, x1, y1 = box
        for a, b in (((x0, y0), (x1, y0)), ((x1, y0), (x1, y1)),
                     ((x1, y1), (x0, y1)), ((x0, y1), (x0, y0))):
            self.dashed(a, b, fill=fill, width=width, dash=dash, gap=gap)

    def vtext(self, x, y, s, size=11, bold=True, fill=INK, up=True):
        """Rotated (vertical) text, like the group labels in the reference GIF."""
        f = font(size, bold)
        tmp = Image.new("RGBA", (1, 1))
        bbox = ImageDraw.Draw(tmp).textbbox((0, 0), s, font=f)
        tw, th = bbox[2] - bbox[0] + 8, bbox[3] - bbox[1] + 8
        lay = Image.new("RGBA", (tw, th), (255, 255, 255, 0))
        ImageDraw.Draw(lay).text((4 - bbox[0], 4 - bbox[1]), s, font=f, fill=fill)
        lay = lay.rotate(90 if up else 270, expand=True)
        self.img.paste(lay, (int(x * S - lay.width / 2), int(y * S - lay.height / 2)), lay)

    def result(self):
        return self.img.resize((self.w, self.h), Image.LANCZOS)


# ------------------------------------------------------------------ edges
def arrow(c, pts, label=None, label_size=10, label_off=(0, -13), fill=INK,
          width=1.4, head=7, label_bold=False, label_pos=0.5, label_bg=True):
    c.line(pts, fill=fill, width=width)
    (x0, y0), (x1, y1) = pts[-2], pts[-1]
    a = math.atan2(y1 - y0, x1 - x0)
    c.poly([(x1, y1),
            (x1 - head * math.cos(a - 0.42), y1 - head * math.sin(a - 0.42)),
            (x1 - head * math.cos(a + 0.42), y1 - head * math.sin(a + 0.42))], fill=fill)
    if label:
        lx, ly = point_on(pts, label_pos)
        if label_bg:
            f = font(label_size, label_bold)
            bb = c.d.textbbox(((lx + label_off[0]) * S, (ly + label_off[1]) * S), label,
                              font=f, anchor="mm", align="center")
            c.d.rectangle([bb[0] - 4 * S, bb[1] - 2 * S, bb[2] + 4 * S, bb[3] + 2 * S],
                          fill=(255, 255, 255))
        c.text(lx + label_off[0], ly + label_off[1], label, size=label_size,
               bold=label_bold, fill=fill)


def plen(pts):
    return sum(math.hypot(pts[i + 1][0] - pts[i][0], pts[i + 1][1] - pts[i][1])
               for i in range(len(pts) - 1))


def point_on(pts, t):
    total = plen(pts)
    target = max(0.0, min(1.0, t)) * total
    acc = 0.0
    for i in range(len(pts) - 1):
        (x0, y0), (x1, y1) = pts[i], pts[i + 1]
        seg = math.hypot(x1 - x0, y1 - y0)
        if acc + seg >= target or i == len(pts) - 2:
            k = 0 if seg == 0 else (target - acc) / seg
            return x0 + (x1 - x0) * k, y0 + (y1 - y0) * k
        acc += seg
    return pts[-1]


def travellers(c, pts, t, n=2, r=3.4, fill=INK, trail=True):
    """Draw n evenly-spaced dots moving along the path at phase t in [0,1)."""
    for k in range(n):
        u = (t + k / n) % 1.0
        x, y = point_on(pts, u)
        if trail:
            for j, (d, rr) in enumerate(((0.020, r * 0.62), (0.040, r * 0.40))):
                tx, ty = point_on(pts, max(0.0, u - d))
                c.dot(tx, ty, rr, fill=(150, 150, 150))
        c.dot(x, y, r, fill=fill)


def shorten(p0, p1, a=0, b=0):
    """Trim a segment at both ends so arrows don't touch icons."""
    (x0, y0), (x1, y1) = p0, p1
    d = math.hypot(x1 - x0, y1 - y0) or 1
    ux, uy = (x1 - x0) / d, (y1 - y0) / d
    return [(x0 + ux * a, y0 + uy * a), (x1 - ux * b, y1 - uy * b)]


# ------------------------------------------------------------------ icons
def terraform(c, x, y, s=1.0, label="Terraform"):
    """Terraform's four-rhombus mark."""
    w, h = 17 * s, 20 * s

    def rhom(cx, cy, col):
        c.poly([(cx, cy - h / 2), (cx + w / 2, cy - h / 4),
                (cx + w / 2, cy + h / 4), (cx, cy + h / 2),
                (cx - w / 2, cy + h / 4), (cx - w / 2, cy - h / 4)], fill=col)
        # parallelogram look: left slab
    def slab(px, py, col):
        c.poly([(px, py), (px + w, py + h * 0.5),
                (px + w, py + h * 1.5), (px, py + h)], fill=col)

    slab(x - w * 1.5, y - h * 0.95, TF_PURPLE_D)
    slab(x - w * 0.45, y - h * 1.45, TF_PURPLE)
    slab(x - w * 0.45, y - h * 0.2, TF_PURPLE)
    slab(x + w * 0.6, y - h * 1.95, TF_PURPLE_D)
    if label:
        c.text(x, y + h * 1.35, label, size=11, bold=True)


def bucket(c, x, y, s=1.0, label="S3", sub=None, col=S3_GREEN):
    w, h = 44 * s, 40 * s
    top = y - h / 2
    c.poly([(x - w / 2, top + 6), (x + w / 2, top + 6),
            (x + w / 2 - 6, top + h), (x - w / 2 + 6, top + h)], fill=col)
    c.ellipse((x - w / 2, top, x + w / 2, top + 12), fill=(255, 255, 255),
              outline=col, width=2.2)
    c.line([(x - w / 2 + 11, top + 16), (x + w / 2 - 11, top + 16)],
           fill=(255, 255, 255), width=1.6)
    if label:
        c.text(x, y + h / 2 + 12, label, size=11, bold=True)
    if sub:
        c.text(x, y + h / 2 + 26, sub, size=8.5, fill=GREY)


def database(c, x, y, s=1.0, label="DynamoDB", col=DDB_BLUE, sub=None):
    w, h = 42 * s, 42 * s
    top, bot = y - h / 2, y + h / 2
    c.rect((x - w / 2, top + 7, x + w / 2, bot - 7), fill=col)
    c.ellipse((x - w / 2, bot - 16, x + w / 2, bot), fill=col)
    c.ellipse((x - w / 2, top, x + w / 2, top + 14), fill=(255, 255, 255),
              outline=col, width=2.2)
    for dy in (14, 24):
        c.ellipse((x - w / 2, top + dy, x + w / 2, top + dy + 12), outline=(255, 255, 255),
                  width=1.4)
    if label:
        c.text(x, bot + 12, label, size=11, bold=True)
    if sub:
        c.text(x, bot + 26, sub, size=8.5, fill=GREY)


def server(c, x, y, s=1.0, label="EC2", n=3, col=AWS_ORANGE, sub=None):
    w = 44 * s
    bh = 11 * s
    top = y - (n * (bh + 3) - 3) / 2
    for i in range(n):
        ty = top + i * (bh + 3)
        c.rect((x - w / 2, ty, x + w / 2, ty + bh), fill=col, radius=2)
        c.dot(x - w / 2 + 7, ty + bh / 2, 2, fill=(255, 255, 255))
        c.line([(x - w / 2 + 14, ty + bh / 2), (x + w / 2 - 7, ty + bh / 2)],
               fill=(255, 255, 255), width=1.2)
    if label:
        c.text(x, top + n * (bh + 3) + 8, label, size=11, bold=True)
    if sub:
        c.text(x, top + n * (bh + 3) + 22, sub, size=8.5, fill=GREY)


def laptop(c, x, y, s=1.0, label="Developer"):
    w, h = 50 * s, 32 * s
    c.rect((x - w / 2, y - h / 2 - 4, x + w / 2, y + h / 2 - 8), fill=DARK, radius=3)
    c.rect((x - w / 2 + 4, y - h / 2, x + w / 2 - 4, y + h / 2 - 12), fill=(232, 240, 254))
    c.text(x, y - 5, ">_", size=10, bold=True, fill=DARK)
    c.poly([(x - w / 2 - 7, y + h / 2 - 4), (x + w / 2 + 7, y + h / 2 - 4),
            (x + w / 2 - 2, y + h / 2 - 8), (x - w / 2 + 2, y + h / 2 - 8)], fill=(90, 95, 102))
    if label:
        c.text(x, y + h / 2 + 10, label, size=11, bold=True)


def kubernetes(c, x, y, s=1.0, label="EKS", sub=None):
    r = 23 * s
    pts = [(x + r * math.cos(math.radians(-90 + i * 360 / 7)),
            y + r * math.sin(math.radians(-90 + i * 360 / 7))) for i in range(7)]
    c.poly(pts, fill=K8S_BLUE)
    ri = r * 0.50
    for i in range(7):
        a = math.radians(-90 + i * 360 / 7 + 25)
        c.line([(x, y), (x + ri * math.cos(a), y + ri * math.sin(a))],
               fill=(255, 255, 255), width=2.0)
    c.dot(x, y, r * 0.24, fill=(255, 255, 255))
    if label:
        c.text(x, y + r + 12, label, size=11, bold=True)
    if sub:
        c.text(x, y + r + 26, sub, size=8.5, fill=GREY)


def statefile(c, x, y, s=1.0, label=None, col=(70, 80, 95), tint=(240, 243, 248)):
    w, h = 32 * s, 40 * s
    fold = 10 * s
    c.poly([(x - w / 2, y - h / 2), (x + w / 2 - fold, y - h / 2),
            (x + w / 2, y - h / 2 + fold), (x + w / 2, y + h / 2),
            (x - w / 2, y + h / 2)], fill=tint, outline=col, width=1.6)
    c.poly([(x + w / 2 - fold, y - h / 2), (x + w / 2, y - h / 2 + fold),
            (x + w / 2 - fold, y - h / 2 + fold)], fill=col)
    for i in range(3):
        c.line([(x - w / 2 + 6, y - 6 + i * 8), (x + w / 2 - 6, y - 6 + i * 8)],
               fill=col, width=1.3)
    if label:
        c.text(x, y + h / 2 + 11, label, size=10, bold=True)


def lock(c, x, y, s=1.0, col=(214, 158, 46), closed=True):
    w, h = 20 * s, 16 * s
    c.d.arc([(x - w / 2 + 3) * S, (y - h * 0.95) * S, (x + w / 2 - 3) * S, (y + 6) * S],
            180, 360, fill=col, width=int(3.2 * S))
    c.rect((x - w / 2, y - 1, x + w / 2, y + h - 1), fill=col, radius=3)
    c.dot(x, y + h / 2 - 2, 2.2, fill=(255, 255, 255))


def folder(c, x, y, s=1.0, label=None, col=(96, 125, 160), sub=None):
    w, h = 48 * s, 36 * s
    c.poly([(x - w / 2, y - h / 2), (x - w / 2 + 16, y - h / 2),
            (x - w / 2 + 22, y - h / 2 + 6), (x + w / 2, y - h / 2 + 6),
            (x + w / 2, y + h / 2), (x - w / 2, y + h / 2)], fill=col)
    c.rect((x - w / 2 + 5, y - h / 2 + 12, x + w / 2 - 5, y + h / 2 - 5),
           fill=(248, 250, 252))
    if label:
        c.text(x, y + h / 2 + 11, label, size=11, bold=True)
    if sub:
        c.text(x, y + h / 2 + 25, sub, size=8.5, fill=GREY)


def cloudbox(c, box, label, col=AWS_ORANGE, sub=None):
    c.dashed_rect(box, fill=col, width=1.4, dash=7, gap=5)
    c.text(box[0] + 4, box[1] + 9, label, size=9.5, bold=True, fill=col, anchor="lm")
    if sub:
        c.text(box[2] - 4, box[1] + 9, sub, size=8.5, fill=col, anchor="rm")


def save_gif(path, frames, duration=70, colors=48):
    """Quantise every frame against one shared palette so GIF delta-compression
    actually works. Without this a 60-frame diagram lands around 2.7 MB."""
    pal = frames[0].convert("RGB").quantize(colors=colors, method=Image.MEDIANCUT)
    qs = [f.convert("RGB").quantize(palette=pal, dither=Image.NONE) for f in frames]
    qs[0].save(path, save_all=True, append_images=qs[1:], duration=duration,
               loop=0, optimize=True, disposal=1)
