# Diagrams

Animated flow diagrams used in the top-level README.

| File | Topic |
|---|---|
| `terraform-state-management.gif` | Remote backend: S3 state + DynamoDB locking |
| `terraform-workspaces.gif` | One config, three isolated environments |
| `terraform-eks.gif` | VPC + EKS control plane + managed node group |

## Regenerating

Pure Python, Pillow only — no design tool needed.

```bash
pip install pillow
cd assets/src
python3 g1_state.py        # writes ../terraform-state-management.gif
python3 g2_workspaces.py
python3 g3_eks.py

python3 g1_state.py --png  # single frame preview, for faster iteration
```

`diagram.py` is the shared framework: a 2x-supersampled canvas, hand-drawn vector icons (Terraform mark, S3 bucket, DynamoDB, EC2, Kubernetes wheel, padlock, state file), polyline arrows, and dots that travel along those polylines to animate flow. Frames are quantised against one shared palette so GIF delta compression works — that is the difference between 2.7 MB and 150 KB.
