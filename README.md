```bash
cd
git clone https://github.com/hmepas/common-dot-files.git
cd common-dot-files
for i in bashrc  dir_colors  gitconfig  tmux.conf profile; do
    cp $i ~/.$i
done
mkdir ~/bin
curl https://raw.githubusercontent.com/hmepas/foose/master/foose > ~/bin/p
chmod +x ~/bin/p
curl https://raw.githubusercontent.com/hmepas/scripts/master/find > ~/bin/find
chmod +x ~/bin/find

wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O ~/bin/z.sh
chmod +x ~/bin/z.sh
```
