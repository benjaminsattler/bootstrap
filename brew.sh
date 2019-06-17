#!/bin/sh

set +evx

brew=brew

function usage() {
    echo Usage: $0 [-h] [-i \<CSV file\>]
    echo
    echo -h: Print this help information
    echo -i: Read brew packages from the given csv file instead of the default
    echo
}

type brew > /dev/null 2>&1 || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

while getopts "i:h" o; do case "${o}" in
    i) packagesfile=${OPTARG} ;;
    ?) usage; exit 0; ;;
    h) usage; exit 0; ;;

esac done

[[ -z "${packagesfile}" ]] && packagesfile=https://raw.githubusercontent.com/benjaminsattler/bootstrap/master/data/brew.csv

oldifs=${IFS}
IFS=,
curl -fsSL "${packagesfile}" | while read package type
do
    [[ "${type}" == "cask" ]] && cask=cask || cask=''
    tmpfile=$(mktemp)
    exec 3>"${tmpfile}"
    exec 4<"${tmpfile}"
    rm ${tmpfile}
    ${brew} ${cask} list ${package} > /dev/null 2>&1
    if [[ "$?" == "0" ]]
    then
        echo Upgrading ${package}
        $(${brew} ${cask} upgrade ${package} >&3 2>&1)
    else
        echo Installing ${package}
        ${brew} ${cask} install ${package}
    fi
    brewstatus=$?
    err=$(cat <&4)
    if [[ "${brewstatus}" != "0" ]]
    then
        $(echo ${err} | grep "already installed" > /dev/null 2>&1) || echo ${err}
    fi
done

