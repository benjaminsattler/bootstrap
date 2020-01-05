#!/bin/bash

set +evx
zsh_binary="/usr/local/bin/zsh"

grep "${zsh_binary}" /etc/shells > /dev/null 2>&1
if [[ "$?" == "1" && -e "${zsh_binary}" ]]; then
    if [[ "$EUID" != "0" ]]; then
        echo "Cannot install zsh as shell. Please run as root."
        exit
    fi
    echo "Installing zsh as shell. Please enter root password for this:"
    echo "${zsh_binary}" | sudo tee -a /etc/shells
    echo "Shell installed. Now please run this script again as your non-root user that you want to change the shell for."
    exit
fi

if [[ "$SHELL" == "${zsh_binary}" ]]; then
    echo "Default shell already set correctly."
else
    chsh -u "$(whoami)" -s "${zsh_binary}"
fi
