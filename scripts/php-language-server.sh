#!/bin/bash

set +evx

pushd ~/src/php-language-server > /dev/null || exit

composer install

popd > /dev/null || exit
