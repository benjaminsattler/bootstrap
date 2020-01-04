#!/bin/bash

set +evx

git=git

function usage() {
    echo Usage: "$0" [-h] [-r \<CSV file\>] [-t \<directory\>]
    echo
    echo -h: Print this help information
    echo -r: Read repositories from the given csv file instead of the default
    echo -t: Clone repositories into the given directory instead of the default
    echo
}

while getopts "r:t:h" o; do case "${o}" in
    r) reposfile=${OPTARG} ;;
    t) repostargetdir=${OPTARG} ;;
    h) usage; exit 0; ;;
    ?) usage; exit 0; ;;
esac done

[[ -z "${reposfile}" ]] && reposfile=https://raw.githubusercontent.com/benjaminsattler/bootstrap/master/data/repos.csv
[[ -z "${repostargetdir}" ]] && repostargetdir=~/src/

echo Using repositories from ${reposfile}
echo Cloning repos into ${repostargetdir}


if ! type ${git} > /dev/null 2>&1; then
    echo Git must be available
    exit 1
fi

if [[ ! -d "${repostargetdir}" ]]; then
    mkdir -p ${repostargetdir}
fi

IFS=,
curl -fsSl "${reposfile}" | while read -r repourl
do
    tmpfile=$(mktemp)
    exec 3>"${tmpfile}"
    exec 4<"${tmpfile}"
    rm "${tmpfile}"
    target=$(echo "${repourl}" | rev | cut -d / -f 1 | cut -d . -f '2-' | rev)
    if [[ -d "${repostargetdir}${target}" ]]
    then
        echo Updating "${target}" to latest version
        pushd "${repostargetdir}${target}" > /dev/null || exit
        ${git} pull >&3 2>&1
        gitstatus=$?
        popd > /dev/null || exit
    else
        echo Cloning "${target}"
        pushd ${repostargetdir} > /dev/null || exit
        ${git} clone "${repourl}" >&3 2>&1
        gitstatus=$?
        popd > /dev/null || exit
    fi
    [[ "${gitstatus}" != "0" ]] && cat <&4
done
