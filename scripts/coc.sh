#!/bin/sh

set +evx

wd=~/.vim/bundle/coc.nvim/

plugins=(
    coc-tsserver        # javscript/typescript
    coc-vetur           # vue
    coc-solargraph      # ruby
    coc-phpls           # php
    coc-json            # json
    coc-html            # html
)

yarn --cwd=${wd} install

for plugin in ${plugins[@]}
do
    vim -c "CocInstall -sync ${plugin}|q"
done
