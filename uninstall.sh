#!/usr/bin/env sh

app_dir="$HOME/.spf13-vim-3"

warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

rm $HOME/.vimrc
rm $HOME/.vimrc.plugs
rm $HOME/.vimrc.local
rm $HOME/.vim

rm -rf $app_dir
