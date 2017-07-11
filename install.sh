#!/bin/bash

APP_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

lnif() {
    if [ ! -e "$2" ]; then
        echo "INFO: Creating link $2 to $1"
        ln -sf "$1" "$2"
    else
        echo "INFO: Link $2 already exists."
    fi
    ret="$?"
}
if [ -e "$APP_PATH" ]; then
    echo "Updating installation"
    git -C $APP_PATH pull
else
    echo "Path $APP_PATH does not exist"
    exit 0
fi

DEIN_PATH=$APP_PATH/bundle/repos/github.com/Shougo/dein.vim
if [ ! -e $DEIN_PATH ];then
    mkdir -p "$DEIN_PATH"
    git clone https://github.com/Shougo/dein.vim $DEIN_PATH
fi
git -C $DEIN_PATH pull


echo "Update using -  :call dein#install()"
