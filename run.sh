#!/bin/sh

#install zsh
sudo apt-get install zsh wget tmux
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh


#instal vim
mv vim ~/.vim
ln -sf ~/.vim/.vimrc ~/.vimrc
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim


echo "Lauch Vim and run: :PluginInstall"

