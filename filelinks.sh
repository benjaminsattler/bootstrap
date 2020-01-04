#!/bin/bash

set +evx

ln=ln
mkdir=mkdir

function usage() {
    echo Usage: $0 [-h] [-l \<CSV file\>]
    echo
    echo -h: Print this help information
    echo -l: Read filelinks from the given csv file instead of the default
    echo
}

while getopts "l:h" o; do case "${o}" in
    l) linksfile=${OPTARG} ;;
    ?) usage; exit 0; ;;
    h) usage; exit 0; ;;
esac done

[[ -z "${linksfile}" ]] && linksfile=https://raw.githubusercontent.com/benjaminsattler/bootstrap/master/data/filelinks.csv

lLDIFS=${IFS}
IFS=,
curl -fsSL "${linksfile}" | while read source destination
do
    source=$(eval echo ${source})
    destination=$(eval echo ${destination})
    tmpfile=$(mktemp)
    exec 3>"${tmpfile}"
    exec 4<"${tmpfile}"
    rm ${tmpfile}
    if [[ ! -e "${source}" ]]
    then
        echo ${source} does not exist, doing nothing
        continue
    fi
    [[ -e "${destination}" && -L "${destination}" ]] && echo ${destination} exists, doing nothing && continue
    [[ -e "${destination}" ]] && echo ${destination} is a file, backing up && mv ${destination} ${destination}.bak
    [[ -e "${destination}" ]] || echo linking ${source} to ${destination} && $mkdir -p $(dirname ${destination}) >&3 2>&1 && $ln -s ${source} ${destination} >&3 2>&1
    [[ -z $? ]] || cat <&4
done
