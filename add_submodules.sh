#!/bin/bash
cur_dir=$(pwd)
for folder in .vim/bundle/*; do
    if [ -d $folder ]; then
        cd $folder
        origin=$(git remote get-url origin)
        cd $cur_dir
        echo git rm --cached $folder
        git submodule add $origin $folder
    fi
done;
