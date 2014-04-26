```bash
cd
git clone https://github.com/hmepas/common-dot-files.git
cd common-dot-files
for i in bashrc  dir_colors  gitconfig  tmux.conf; do
    cp $i ~/.$i
done
```
