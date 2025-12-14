#!/bin/bash

if [ ! -d "~/.vim/autoload/" ]; then
    echo "Autoload directory being created..."
    mkdir -p ~/.vim/autoload/
fi

if [[ $* == *--backup* ]]; then
    RANDOM_STRING=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)
    echo "Copying current vimrc to current directory"
    cp ~/.vimrc ./.vimrc.${RANDOM_STRING}.bak
    mkdir ./.vim_${RANDOM_STRING}_backup
    cp -r ~/.vim/* ./.vim_${RANDOM_STRING}_backup
    echo "Successfully made backup with name \".vimrc.${RANDOM_STRING}.bak\" and .vim backup folder \".vim_${RANDOM_STRING}_backup\" respectively."
fi

echo "Copying vim plug to directory."
cp -R .vim/* ~/.vim
echo "Copied to correct directory."

echo "Copying vimrc to user directory."
cp .vimrc ~/.vimrc
echo "Copied vimrc to user directory."

echo "All ready to use!"