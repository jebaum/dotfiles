#!/bin/bash
cd ~/dotfiles
git submodule foreach git checkout master
git submodule foreach git pull
git add vim/bundle/*
git commit -m 'update submodules'
cd ~/dotfiles/vim/bundle/vim-fugitive
git checkout james
git merge master
