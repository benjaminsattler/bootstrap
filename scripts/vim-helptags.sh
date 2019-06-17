#!/bin/sh

set +evx

function usage() {
    echo Usage: $0 [-h] [-p \<directory\>]
    echo
    echo -h: Print this help information
    echo -p: Use the given directory to look for installed vim plugins instead of the default
    echo
}

while getopts "p:h" o; do case "${o}" in
    p) pluginpath=${OPTARG} ;;
    ?) usage; exit 0; ;;
    h) usage; exit 0; ;;
esac done

[[ -z  "${pluginpath}" ]] && pluginpath=~/.vim/bundle/
[[ ! -d "${pluginpath}" ]] && echo pluginpath ${pluginpath} not found. && exit

plugins=(
    'coc.nvim'
    'ctrlp-py-matcher'
    'ctrlp.vim'
    'ranger.vim'
    'vim-airline'
    'vim-airline-themes'
    'vim-fugitive'
    'vim-gitgutter'
    'vim-gutentags'
    'vim-localvimrc'
    'vim-rspec'
    'vim-solarized8'
    'tagbar'
)

for plugin in ${plugins[@]}
do
    echo Installing helptags for ${plugin}
    vim -es -c "helptags ${pluginpath}${plugin}/doc/" -c "q"
done
