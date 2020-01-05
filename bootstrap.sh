#!/bin/bash

set +evx

curl -fsSL https://raw.githubusercontent.com/benjaminsattler/bootstrap/master/brew.sh | /bin/sh
curl -fsSL https://raw.githubusercontent.com/benjaminsattler/bootstrap/master/repos.sh | /bin/sh
curl -fsSL https://raw.githubusercontent.com/benjaminsattler/bootstrap/master/filelinks.sh | /bin/sh

curl -fsSL https://raw.githubusercontent.com/benjaminsattler/bootstrap/master/scripts/changeshell.sh | /bin/sh
curl -fsSL https://raw.githubusercontent.com/benjaminsattler/bootstrap/master/scripts/php-language-server.sh | /bin/sh
