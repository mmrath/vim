#!/bin/bash

APP_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
}
if [ -e "$APP_PATH" ]; then
    echo "Updating installation"
    cd $APP_PATH
    git pull
else
    echo "Path $APP_PATH does not exist"
    exit 0
fi

lnif "$APP_PATH/.vimrc" "$HOME/.vimrc" 
lnif "$APP_PATH/.vim" "$HOME/.vim" 

if [ ! -e $APP_PATH/.vim/bundle ];then
    mkdir -p "%APP_PATH%\.vim\bundle"
fi

if [ ! -e "$HOME/.vim/bundle/Vundle.vim" ]; then 
    git clone https://github.com/VundleVim/Vundle.vim.git $APP_PATH/.vim/bundle/Vundle.vim
else 
  cd "$HOME/.vim/bundle/Vundle.vim"
  git pull
  cd $APP_PATH
fi

vim +PluginInstall +PluginClean +qall
