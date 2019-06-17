#!/bin/sh

set +evx

chsh --shell=`grep zsh /etc/shells | head -n 1` `whoami`
