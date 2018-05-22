#!/bin/bash
sudo yum install -y tmux
sudo yum install -y git 
wget -O - https://raw.githubusercontent.com/joeyism/.files/master/run.sh | bash -
echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '" >> .bashrc
. ~/.bashrc
