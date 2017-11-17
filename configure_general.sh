#!/bin/bash
wget https://raw.githubusercontent.com/joeyism/.files/master/.vimrc 
wget https://raw.githubusercontent.com/joeyism/.files/master/.tmux.conf
sudo yum install -y tmux
sudo yum install -y git 
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '" >> .bashrc
. ~/.bashrc
