#!/bin/sh

set +evx

wd=~/.config/coc/extensions

plugins=(
    coc-phpls           # php
    coc-tsserver        # javscript/typescript
    coc-solargraph      # ruby
)
cd ${wd}
~/.vim/bundle/coc.nvim/install.sh nightly

for plugin in ${plugins[@]}
do
    yarn --cwd=${wd} add ${plugin}
done
