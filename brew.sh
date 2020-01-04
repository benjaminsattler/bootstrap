#!/bin/bash

set +evx

brew=brew

function usage() {
    echo Usage: "${0}" [-h] [-i \<CSV file\>]
    echo
    echo -h: Print this help information
    echo -i: Read brew packages from the given Brewfile instead of the default
    echo
}

type ${brew} > /dev/null 2>&1 || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

while getopts "i:h" o; do case "${o}" in
    i) packagesfile=${OPTARG} ;;
    h) usage; exit 0; ;;
    ?) usage; exit 0; ;;

esac done

[[ -z "${packagesfile}" ]] && packagesfile=https://raw.githubusercontent.com/benjaminsattler/bootstrap/master/Brewfile

curl -fsSL "${packagesfile}" | ${brew} bundle --file=-

