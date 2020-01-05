#!/bin/bash

set +evx

git="git"

function usage() {
    echo Usage: "$0" [-h] [-r \<CSV file\>]
    echo
    echo -h: Print this help information
    echo -r: Read repositories from the given csv file instead of the default
    echo
}

while getopts "r:h" o; do case "${o}" in
    r) reposfile="${OPTARG}" ;;
    h) usage; exit 0; ;;
    ?) usage; exit 0; ;;
esac done

[[ -z "${reposfile}" ]] && reposfile=https://raw.githubusercontent.com/benjaminsattler/bootstrap/master/data/repos.csv

echo Using repositories from "${reposfile}"

if ! type "${git}" > /dev/null 2>&1; then
    echo Git must be available
    exit 1
fi

IFS=,
curl -fsSl "${reposfile}" | while read -r repourl repotargetdir
do
    tmpfile=$(mktemp)
    exec 3>"${tmpfile}"
    exec 4<"${tmpfile}"
    rm "${tmpfile}"
    target=$(echo "${repourl}" | rev | cut -d / -f 1 | cut -d . -f '2-' | rev)
    repotargetdir=$(eval echo "${repotargetdir}")
    if [[ -d "${repotargetdir}" ]]
    then
        echo Updating "${target}" to latest version
        ${git} -C "${repotargetdir}" pull >&3 2>&1
        gitstatus=$?
    else
        echo Cloning "${target}" into "${repotargetdir}"
        ${git} clone "${repourl}" "${repotargetdir}" >&3 2>&1
        gitstatus=$?
    fi
    [[ "${gitstatus}" != "0" ]] && cat <&4
done
