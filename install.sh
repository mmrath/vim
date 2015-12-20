#!/bin/bash

APP_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

lnif() {
    if [ ! -e "$2" ]; then
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

NEOBUNDLE_PATH=$HOME/.vim/bundle/neobundle.vim
if [ "$(ls -A $NEOBUNDLE_PATH)" ]; then
  #Not Empty
  cd "$NEOBUNDLE_PATH"
  git pull
  cd $APP_PATH
else
  #Empty
  git clone https://github.com/Shougo/neobundle.vim $NEOBUNDLE_PATH
fi

vim +NeoBundleInstall +NeoBundleClean +qall
