#!/bin/bash

usage="$(basename "$0") [-h] [-N PROJECTNAME] [-U GITURL] [-V VISIBILITY] [-P PATH]
Project name is mandatory, visibility must be 0 (public) or 1 (private, default)
where:
    -h  show this help text
    -N  Project name
    -U  Giturl
    -V  Set repository visibility, 0=Public 1=Private(default)
    -P  Local path"

# constants
giturl=https://github.com/Krikke99/
visibility=1
path=$HOME/repos/
gitext=".git"

while getopts h:N:U:V:P: flag
do
    case "${flag}" in
        h) echo "$usage"; exit;;
        N) fn=${OPTARG};;
        U) giturl=${OPTARG};;
        V) visibility=${OPTARG};;
        P) path=${OPTARG};;
    esac
done

if [ ! "$fn" ]; then
  echo "argument -N (ProjectName) must be provided"
  echo "$usage" >&2; exit 1
fi

if [[ "$visibility" -ne 0 && "$visibility" -ne 1 ]]; then
    echo "Error: -V visibility can only be 0 (public) or 1 (private)"
    echo "$usage" >&2; exit 1
fi

if [[ "$path" != */ ]]; then 
    workingdir=$path/$fn
else
    workingdir=$path$fn
fi

mkdir $workingdir
cd $workingdir
touch README.md
git init
if [[ "$visibility" -eq 0 ]]; then
    gh repo create $fn --public --source=. --remote=upstream
elif [[ "$visibility" -eq 1 ]]; then
    gh repo create $fn --private --source=. --remote=upstream
fi
git remote add origin $giturl$fn$gitext
git add .
git commit -m "initial commit"
git push -u origin master
code .