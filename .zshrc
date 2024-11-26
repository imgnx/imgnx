#!/bin/zsh -df
# The -df is for --no-globalrcs and --no-rcs

# Profiling (stats on how your shell loads)
zmodload zsh/zprof

alias git-branch="git branch -v"
alias git-remote="git remote -v"

# Rewriting git...
function git() {
  if ! command -v jq &>/dev/null; then
    echo "jq is not installed. Installing jq..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
      brew install jq
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      sudo apt-get update && sudo apt-get install -y jq
    fi
  fi
  if [ "$1" = "branch" ]; then
    command git branch -v "${@:2}"
  elif [ "$1" = "remote" ]; then
    command git remote -v "${@:2}"
  elif [ "$1" = "diff" ]; then
    command git difftool
  elif [ "$1" = "init" ]; then
    writeLicense
    git list
    command git "$@"
  elif [ "$1" = "list" ]; then
    # Get template from imgnxorg/imgnx-repo-template
    echo "Creating repository from imgnxorg template..."
    repoName=$(jq -r '.name' package.json)
    if [ -z "$repoName" ]; then
      echo "Please enter a name for this repository:"
      read repoName
    fi
    echo "Name: \e[38;5;198m$repoName\e[0m"
    command gh repo create "$repoName" --template https://github.com/imgnxorg/imgnx-repo-template --private
    echo "Initializing repo as private. To change the following command:"
    echo "\e^"
    echo "gh repo edit OWNER/REPO --visibility public"
    echo
  else
    command git "$@"
  fi
}

function writeLicense() {
  echo "Writing LICENSE file..."
  cat ~/LICENSE | tee ./LICENSE
}

alias 0bsd=writeLicense

zprof
