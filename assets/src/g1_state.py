import sys
from diagram import *

W, H = 900, 520
NF = 60


def frame(t):
    c = Canvas(W, H)
    c.text(W / 2, 26, "Terraform State Management  —  remote backend + locking",
           size=15, bold=True)
    c.text(W / 2, 46, "S3 stores the state  •  DynamoDB stops two applies colliding",
           size=9.5, fill=GREY)

    # ---- group boxes ----
    cloudbox(c, (22, 70, 248, 492), "LOCAL", col=(110, 118, 130))
    cloudbox(c, (292, 70, 610, 492), "REMOTE BACKEND  (AWS)", col=AWS_ORANGE,
             sub="versioned • encrypted")
    cloudbox(c, (652, 70, 878, 492), "MANAGED INFRASTRUCTURE", col=AWS_ORANGE)

    # ---- nodes ----
    laptop(c, 135, 150, label="Developer")
    terraform(c, 135, 355, label="Terraform CLI")

    database(c, 452, 168, label="DynamoDB", sub="LockID table")
    lock(c, 512, 166)
    bucket(c, 452, 372, label="S3 state bucket", sub="terraform.tfstate")

    server(c, 765, 168, label="EC2 / VPC", n=3)
    bucket(c, 765, 372, label="App resources", col=(72, 150, 110))

    # ---- edges ----
    e_dev = [(135, 186), (135, 300)]
    e_lock = [(182, 340), (300, 260), (410, 196)]
    e_pull = [(180, 366), (398, 372)]
    e_apply = [(500, 350), (600, 300), (700, 205)]
    e_apply2 = [(500, 384), (610, 392), (712, 378)]
    e_write = [(742, 415), (742, 462), (452, 462), (452, 412)]

    arrow(c, e_dev, "terraform apply", label_off=(58, -10), label_size=9.5)
    arrow(c, e_lock, "1  acquire lock   /   5  release", label_off=(-2, -14), label_size=9.5, label_pos=0.30)
    arrow(c, e_pull, "2  pull state", label_off=(0, -12), label_size=9.5)
    arrow(c, e_apply, "3  create / update", label_off=(6, -13), label_size=9.5, label_pos=0.5)
    arrow(c, e_apply2, None)
    arrow(c, e_write, "4  write new state", label_off=(0, 13), label_size=9.5, label_pos=0.55)

    for e, n in ((e_dev, 1), (e_lock, 2), (e_pull, 2), (e_apply, 2),
                 (e_apply2, 2), (e_write, 3)):
        travellers(c, e, t, n=n)

    # ---- footnote ----
    c.text(W / 2, 505,
           "never commit terraform.tfstate  —  it holds resource IDs and plaintext secrets",
           size=9, fill=GREY)
    return c.result()


if __name__ == "__main__":
    if "--png" in sys.argv:
        frame(0.0).save("../preview1.png")
    else:
        save_gif("../terraform-state-management.gif",
                 [frame(i / NF) for i in range(NF)], duration=70)
        print("ok")
