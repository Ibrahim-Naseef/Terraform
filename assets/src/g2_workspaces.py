import sys
from diagram import *

W, H = 900, 520
NF = 60

ENVS = [
    ("dev", 140, "1 x t3.micro", (86, 148, 96)),
    ("stg", 272, "1 x t3.micro", (196, 152, 54)),
    ("prod", 404, "2 x t3.small", (186, 74, 74)),
]


def frame(t):
    c = Canvas(W, H)
    c.text(W / 2, 26, "Terraform Workspaces  —  one configuration, three environments",
           size=15, bold=True)
    c.text(W / 2, 46, "same .tf files  •  separate state file per workspace",
           size=9.5, fill=GREY)

    cloudbox(c, (22, 72, 262, 470), "ONE CONFIG DIRECTORY", col=(110, 118, 130))
    cloudbox(c, (556, 72, 878, 470), "ISOLATED STATE  —  one per workspace",
             col=AWS_ORANGE)

    # ---- left: the single config ----
    folder(c, 132, 148, label="04-workspaces/", sub="main.tf  locals.tf")
    terraform(c, 132, 330, label="terraform workspace")
    c.text(132, 372, "select  dev | stg | prod", size=8.5, fill=GREY)

    e_cfg = [(132, 186), (132, 282)]
    arrow(c, e_cfg, None)
    travellers(c, e_cfg, t, n=1)

    edges = []
    for name, y, size, col in ENVS:
        # fan-out arrow
        e = [(186, 318 + ENVS.index((name, y, size, col)) * 13),
             (300, 296 + ENVS.index((name, y, size, col)) * 6),
             (420, y + 6), (566, y)]
        arrow(c, e, name, label_off=(0, -13), label_size=10.5, label_bold=True,
              label_pos=0.62, fill=col)
        edges.append((e, col))

        c.text(650, y - 28, f"{name}", size=11.5, bold=True, fill=col)
        server(c, 650, y, n=2, col=col, label=None)
        c.text(650, y + 30, size, size=8.5, fill=GREY)

        st = [(690, y), (768, y)]
        arrow(c, st, None, fill=col, width=1.2, head=6)
        edges.append((st, col))

        statefile(c, 806, y, s=0.78)
        c.text(806, y + 27, f"env:/{name}/", size=8, fill=GREY)

    for e, col in edges:
        travellers(c, e, t, n=2, fill=col, r=3.2)

    c.text(717, 452,
           'the "default" workspace has no  env:/  prefix  —  leave it unused',
           size=8, fill=GREY)

    # ---- bottom strip ----
    c.rect((22, 486, 878, 512), fill=(244, 246, 250), radius=5)
    c.text(W / 2, 499,
           "terraform workspace new dev    |    terraform workspace select prod    "
           "|    terraform workspace list",
           size=9.5, bold=True, fill=(70, 80, 95))
    return c.result()


if __name__ == "__main__":
    if "--png" in sys.argv:
        frame(0.0).save("../preview2.png")
    else:
        save_gif("../terraform-workspaces.gif",
                 [frame(i / NF) for i in range(NF)], duration=70)
        print("ok")
