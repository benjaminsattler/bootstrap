#!/bin/bash

set +evx

grep "/usr/local/bin/zsh" /etc/shells > /dev/null 2>&1
if [[ "$?" == "1" && -e "/usr/local/bin/zsh" ]]; then
    if [[ "$EUID" != "0" ]]; then
        echo "Cannot install zsh as shell. Please run as root."
        exit
    fi
    echo "Installing zsh as shell. Please enter root password for this:"
    echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
    echo "Shell installed. Now please run this script again as your non-root user that you want to change the shell for."
    exit
fi
chsh -u "$(whoami)" -s /usr/local/bin/zsh
