#!/bin/sh

set +evx

pushd ~/src/php-language-server

composer install

popd
