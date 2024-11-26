#!/bin/bash

$PWD=$(pwd)                                                                 # Save current working directory
$SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd) # Save
cd $SCRIPT_DIR                                                              # Change to script directory
echo "PWD: $PWD"
echo "SCRIPT_DIR: $SCRIPT_DIR"
echo $(node ./substr_replace.mjs "$1" "$2" "$3")
cd $PWD # Change back to working directory
