Set git global config

```bash
git config --global user.email "bjorn.olav.vangen.aure@outlook.com"
git config --global user.name "Bjørn Olav Vangen Aure"
```

Initialize and push a new repo from directory

```bash
git init
git add .
git commit -m "Initial code"
git branch -M main
git remote add origin git@github.com:aurbjo/my_new_repo.git # if you have setup SSH keys
git remote add origin https://github.com/aurbjo/my_new_repo.git # Use HTTPS (browser to authenticate)
git push -u origin main
```
