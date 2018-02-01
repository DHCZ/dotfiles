#!/bin/sh

#install need
sudo apt-get install sshfs nfs-common lvm2 dkms openssh-server
sudo apt-get install build-essential libopencv-dev python-opencv git htop vim python-dev tmux python-pip python-all-dev libatlas-base-dev gfortran openssh-server libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libboost-all-dev libgflags-dev libgoogle-glog-dev liblmdb-dev graphviz unzip
sudo pip install numpy jupyter pandas scipy scikit-learn matplotlib graphviz easydict

# mout nas

mkdir -p /mnt/truenas/scratch /mnt/truenas/team/algorithm /mnt/truenas/datasets_addon /mnt/truenas/upload /mnt/truenas/datasets
sudo mount -t nfs truenas.bj.tusimple.ai:/mnt/tank/datasets_addon /mnt/truenas/datasets_addon
sudo mount -t nfs truenas.bj.tusimple.ai:/mnt/tank/scratch /mnt/truenas/scratch
sudo mount -t nfs truenas.bj.tusimple.ai:/mnt/tank/team/algorithm /mnt/truenas/team/algorithm
sudo mount -t nfs truenas.bj.tusimple.ai:/mnt/tank/upload /mnt/truenas/upload
sudo mount -t nfs truenas.bj.tusimple.ai:/mnt/tank/datasets /mnt/truenas/datasets


#install zsh
sudo apt-get install zsh wget tmux
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh


#instal vim
mv vim ~/.vim
ln -sf ~/.vim/.vimrc ~/.vimrc
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim


echo "Lauch Vim and run: :PluginInstall"

