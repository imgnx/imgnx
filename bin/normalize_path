#!/bin/bash

# Function to display help
show_help() {
  cat <<EOF | less -B --chop-long-lines --use-color

Usage: normalize_path [-q|--quiet] [-b|--bash] <path>

This script normalizes file paths to a consistent format.

Options:
  -q, --quiet      Suppress output messages. Only errors will be displayed.
  -b, --bash       Normalize the path to a Bash-style path.
  -h, --help       Display this help message and exit.

Arguments:
  <path>           The file path to normalize. This can be a Windows-style path,
                   a Bash-style path, or a relative path.

Description:
  The normalize_path script is designed to handle different styles of file paths
  and convert them to a consistent format. It supports Windows-style paths (e.g.,
  C:\path\to\file), Linux-style paths (e.g., /mnt/c/path/to/file), and relative
  paths. The script can also convert paths to a Bash-style format if the -b or
  --bash option is specified.

Examples:
  normalize_path C:\Users\Example
      Converts the Windows-style path to a normalized format.

  normalize_path -b /mnt/c/Users/Example
      Converts the Linux-style path to a Bash-style format.

  normalize_path ../relative/path
      Converts the relative path to an absolute path.

  normalize_path -q C:\Users\Example
      Converts the Windows-style path to a normalized format without displaying
      any output messages.
EOF
}

quiet_mode=false
bash_style_checkout=false
linux_style_checkout=false
windows_style_checkout=false
relative_style_checkout=false
pwd=$(pwd)
input=""
full_path=""
object_path=""

# Loop through all command-line arguments

for arg in "$@"; do
  # Check for help option
  case $arg in
  -h | --help)
    show_help
    exit 0
    ;;
  esac
  case $arg in
  -q | --quiet)
    # Set the quiet_mode flag
    quiet_mode=true
    shift # Remove the -q from the arguments
    ;;
  esac
  case $arg in
  -b | --posix | --bash)
    # Set Git Bash-style checkout flag
    bash_style_checkout=true
    shift # Remove the -b from the arguments
    ;;
  esac
  case $arg in
  -l | --unix | --linux)
    # Set Linux-style checkout flag
    linux_style_checkout=true
    shift # Remove the -l from the arguments
    ;;
  esac
  case $arg in
  -w | --win | --windows)
    # Set Bash-style checkout flag
    windows_style_checkout=true
    shift # Remove the -w from the arguments
    ;;
  esac
  case $arg in
  -r | --rel | --relative)
    # Set Relative-style checkout flag
    relative_style_checkout=true
    shift # Remove the -r from the arguments
    ;;
  esac
  case $arg in
  *)
    input+="$arg "
    ;;
  esac
done

input="${input% }" # Remove trailing space

if [ ! quiet_mode ]; then
  echo "Input: $input"
fi

if [[ $windows_style_checkout == true ]]; then
  # Windows-style checkout
  if [ ! quiet_mode ]; then
    echo "Windows-style checkout: $1"
  fi
  full_path="${input}"
  object_path="${full_path:2}"
  object_path="${object_path//\\//}"
elif [[ $bash_style_checkout == true ]]; then
  # Bash-style checkout
  if [ ! quiet_mode ]; then
    echo "Bash-style checkout: $1"
  fi
  full_path="${input}"
  object_path="${full_path:2}"
  # Start of Switch for all styles...
elif [[ "$input" =~ ^[a-zA-Z]:\\ ]]; then
  # Windows-style checkout
  if [ ! quiet_mode ]; then
    echo "Windows-style checkout: $1"
  fi
  full_path="${input}"
  object_path="${full_path:2}"
  object_path="${object_path//\\//}"
elif [[ "$input" =~ ^/[a-zA-Z]/ ]]; then
  # Bash-style checkout
  if [ ! quiet_mode ]; then
    echo "Bash-style checkout: $1"
  fi
  full_path="${input}"
  object_path="${full_path:2}"
elif [[ "$input" =~ ^/mnt/[a-zA-Z]/ ]]; then
  # Linux-style checkout
  if [ ! quiet_mode ]; then
    echo "Linux-style checkout: $1"
  fi
  full_path="${input}"
  object_path="${full_path:4}"
else
  # Relative path
  if [ ! quiet_mode ]; then
    echo "Relative path: $1"
  fi
  cd "$pwd" || {
    printf "Read Error: Failed to change directory to %s\n" "$pwd" >&2
    return 1
  }
  full_path="$(realpath "$input")"
  object_path="${full_path:2}"
fi
# End of Switch for all styles...

export imgnx_normalized_path_full_path="$full_path"
export imgnx_normalized_path_object_path="$object_path"

if [[ $full_path == *" "* ]]; then
  echo "\"$full_path\" \"$object_path\""
else
  echo "$full_path  $object_path"
fi

# Note: Do not $(exit) here. The file is sourced, so it will exit the shell.
# exit

# Usage: `res="$(normalize_path <file>)"`
# if [[ $paths =~ \" ]]; then
# 	if [[ $paths =~ ^\"(.*)\"[[:space:]]\"(.*)\"$ ]]; then
# 		full_path="${BASH_REMATCH[1]}"
# 		object_path="${BASH_REMATCH[2]}"
# 	fi
# else
# 	if [[ $paths =~ (.*)[[:space:]](.*) ]]; then
# 		full_path="${BASH_REMATCH[1]}"
# 		object_path="${BASH_REMATCH[2]}"
# 	fi
# fi
# if [[ "$full_path" == "" || "$object_path" == "" ]]; then
# 	if [[ $input =~ (\\$)(\/$)(\.{0}) ]]; then
# 		echo -e "${DEEP_RED}Read Error: Bad path for directory $input${R} 😔"
# 	else
# 		echo -e "${DEEP_RED}Read Error: Bad path for file $input${R} 😔"
# 	fi
# 	exit 1
# fi
