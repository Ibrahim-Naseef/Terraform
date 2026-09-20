# Pushing this to your repo

I can't authenticate to GitHub from here, so this arrives as a zip with a clean
local Git history already committed. Two ways to land it.

## Option A — replace the contents of `main` (recommended)

```bash
unzip Terraform-restructured.zip
cd Terraform

git remote add origin https://github.com/Ibrahim-Naseef/Terraform.git
git fetch origin

# keep the old history as a branch you can always look back at
git branch old-main origin/main
git push origin old-main

git push --force-with-lease origin main
```

## Option B — open a pull request instead

```bash
cd Terraform
git remote add origin https://github.com/Ibrahim-Naseef/Terraform.git
git fetch origin
git checkout -b restructure
git push -u origin restructure
```

Then open a PR from `restructure` into `main` on GitHub.

## Afterwards: purge the leaked state files

`terraform.tfstate` and `terraform.tfstate.backup` are gone from the new tree,
but they are still readable in the old commits. Public repo, so treat them as
compromised.

```bash
pip install git-filter-repo

git filter-repo --invert-paths \
  --path terraform.tfstate \
  --path terraform.tfstate.backup

git push --force-with-lease origin main
```

Then rotate anything those files referenced. With 5 commits and 0 forks this is
about as cheap as a history rewrite ever gets.
