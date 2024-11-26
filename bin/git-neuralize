#!/bin/bash

echo "Called: git-neuralize"

# git-neuralize - Neuralize sensitive data in a git repository
# (re):IMGNX   bash.

# Usage: git-neuralize [ -f | --file <path> || -t | --text <replacements.txt (see below)> ]
# Examples:
# Neuralizing a Path: `git-neuralize -f .env`
# Neuralizing a String: `git-neuralize -t ./replacements.txt`

# Options:
# --file, -f Neuralize a file
# --text, -t Neuralize a string
# --help, -h Display this help message

# Arguments:
# <path> Path of the path to neuralize
# <file> Replacement file for the text to neuralize (see below)

# Note: This script uses `git-filter-repo` to replace sensitive data with random strings.
# Make sure to commit your changes before running this script.
# This script will rewrite the git history.

if [ -f "./colors.sh" ]; then
  . ./colors.sh
else
  echo "Colors not found..."
  AMBER="\e[38;5;227m"
  AWESOME="\e[38;5;202m"
  BLACK="\e[30m"
  BLUE="\e[38;5;20m"
  CERISE="\e[38;5;161m"
  CHARTREUSE="\e[38;5;118m"
  CYAN="\e[36m"
  CYBERPUNK="\e[38;5;198m"
  DARK_RED="\e[38;5;88m"
  DARK_MAGENTA="\e[38;5;90m"
  DEEP_MAGENTA="\e[38;5;164m"
  DEEP_RED="\e[38;5;196m"
  DEEP_PINK="\e[38;5;198m"
  DEEP_PURPLE="\e[38;5;57m"
  DEADED="\e[38;5;135m"
  EGGPLANT="\e[38;5;99m"
  FERRARI_RED="\e[38;5;196m"
  GREEN="\e[32m"
  HARD_ISH_PINK="\e[38;5;200m"
  HELIOTROPE="\e[38;5;171m"
  HOT_PINK="\e[38;5;205m"
  ILLICIT_PURPLE="\e[38;5;56m"
  CORNFLOWER_BLUE="\e[38;5;62m"
  GLOWING_GREEN="\e[38;5;118m"
  LILAC="\e[38;5;183m"
  MAGENTA="\e[35m"
  MIDNIGHT_EXPRESS="\e[38;5;17m"
  MS_PACMAN_KISS_PINK="\e[38;5;213m"
  ORANGE_RED="\e[38;5;202m"
  ORANGE="\e[38;5;208m"
  PEGASUS="\e[38;5;117m"
  DARK_PEGASUS="\e[38;5;117m"
  FLIRT="\e[38;5;126m"
  PEACH="\e[38;5;222m"
  PURPLE="\e[38;5;129m"
  RED="\e[31m"
  PACMAN="\e[38;5;226m"
  RED_ORANGE="\e[38;5;208m"
  ROSE="\e[38;5;170m"
  PINK="\e[38;5;206m"
  SALMON="\e[38;5;209m"
  PERSIAN_RED="\e[38;5;204m"
  PEARL="\e[38;5;231m"
  SILVER="\e[38;5;247m"
  UFO_GREEN="\e[38;5;84m" # UFO Green (#84) - https://en.wikipedia.org/wiki/Shades_of_green#UFO_green
  VIOLETS_ARE_BLUE="\e[38;5;57m"
  YELLOW="\e[33m"
  WHITE="\e[97m"
  WHITESMOKE="\e[38;5;7m"
  STRAWBERRY="\e[38;5;203m"

  # BKGDs
  BKGD_CYBERPUNK="\e[48;5;198m"
  BKGD_DARK_PEGASUS="\e[48;5;117m"
  BKGD_PEGASUS="\e[48;5;117m"
  BKGD_BLACK="\e[40m"
  BKGD_WHITE="\e[47m"
  BKGD_YELLOW="\e[43m"
  BKGD_LIGHT_YELLOW="\e[48;5;228m"
  BKGD_CYAN="\e[46m"
  BKGD_MAGENTA="\e[45m"
  BKGD_GLOWING_GREEN="\e[48;5;118m"
  BKGD_BLUE="\e[48;5;20m"
  BKGD_PURPLE="\e[48;5;57m"
  BKGD_PERSIAN_RED="\e[48;5;204m"
  BKGD_RED="\e[41m"
  BKGD_UFO_GREEN="\e[48;5;84m"
  BKGD_VIOLETS_ARE_BLUE="\e[48;5;57m"

  # Vars
  RESET="\e[0m"
  BOLD="\e[1m"
  NORMAL="\e[22m"
  ITALIC="\e[3m"
  DIM="\e[2m"
  CLEARFILL="\e[K"

  WIPE="\e[0J"

  # Vars
  R=${RESET}
  B=${BOLD}
  N=${NORMAL}
  I=${ITALIC}
  D=${DIM}
  W=${WIPE}
  CF=${CLEARFILL}

fi

function help() {
  cat <<EOF | less -R -X -F -K -S -M -i -P " [Use arrows to move, 'q' to quit.]" -P " [Use arrows to move, 'q' to quit.]"
  
${B}git-neuralize${R} - Neuralize sensitive data in a git repository
${D}(re):IMGNX   bash.${R}

${B}Usage\: ${AMBER}${B}git-neuralize [ -f | --file \<path\> || -t | --text \<replacements.txt \(see below\)\> ]${R}
${D}Examples:
Neuralizing a Path: ${R}${WHITE}\`git-neuralize -f .env\`${D}
Neuralizing a String: ${R}${WHITE}\`git-neuralize -t ./replacements.txt\`${D}

Options:
--file, -f ${D}Neuralize a file${R}
--text, -t ${D}Neuralize a string${R}
--help, -h ${D}Display this help message

Arguments:
\<path\> Path of the path to neuralize
\<file\> Replacement file for the text to neuralize \(see below\)

Note: This script uses \`git-filter-repo\` to replace sensitive data with random strings.
Make sure to commit your changes before running this script.
This script will rewrite the git history.

Generate a replacement file using the following command:${R}

${D}bash/zsh\:${R}
echo 'ORIGINAL===>REPLACEMENT' >replacements.txt

${D}powershell\:${R}
echo 'ORIGINAL===>REPLACEMENT' | Out-File -FilePath replacements.txt

${D}cmd:
echo 'ORIGINAL=== >REPLACEMENT' >replacements.txt

${D}Then run the following command:${R}

git-neuralize -t ./replacements.txt
EOF
  exit 0
}

if [ $# -eq 0 ]; then
  help
else
  if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help
  elif [ "$1" == "--file" ] || [ "$1" == "-f" ]; then
    if [ -z "$2" ]; then
      echo "${RED}${B}Error: Missing path to the file to neuralize${R}"
    else
      git filter-repo --use-base-name --path $2 --invert-path
    fi
  elif [ "$1" == "--text" ] || [ "$1" == "-t" ]; then
    if [ -z "$2" ]; then
      echo "${RED}${B}Error: Missing path to the file containing the text to neuralize${R}"
    else
      git filter-repo --replace-text $2 --force
    fi
  else
    echo "${RED}${B}Error: Invalid option: $1 ${R}"
    help
  fi
fi

echo "EOF"
exit 0
