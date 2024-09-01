#!/bin/bash
file=$1
test -z $file && echo "file required." 1>&2 && exit 1
echo "IMGNX Warning: This will remove all traces of $file from the git history. However, it will also rebase everything and destroy any stashes. Are you sure you want to proceed? (y/n)"
read confirm
test $confirm != "y" && echo "Aborted." && exit 1

git filter-branch -f --index-filter "git rm -r --cached $file --ignore-unmatch" --prune-empty --tag-name-filter cat -- --all
git ignore $file
git add .gitignore
git commit -m "Add $file to .gitignore"
