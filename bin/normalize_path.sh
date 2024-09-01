# Normalizing path...
echo "Normalizing path: $1"
if [[ "$1" =~ ^[a-zA-Z]:\\ ]]; then
  # Windows-style path (e.g., C:\path\to\file)
  echo "Windows-style path (e.g., C:\path\to\file): $1"
  path="${input}"
  object_path="${path:2}"
  object_path="${object_path//\\//}"
elif [[ "$1" =~ ^/mnt/[a-zA-Z]/ ]]; then
  # Bash-style path with /mnt/ prefix (e.g., /mnt/c/path/to/file)
  echo "Bash-style path with /mnt/ prefix (e.g., /mnt/c/path/to/file): $1"
  path="${input}"
  object_path="${path:4}"
elif [[ "$1" =~ ^/[a-zA-Z]/ ]]; then
  # Bash-style path without /mnt/ prefix (e.g., /c/path/to/file)
  echo "Bash-style path without /mnt/ prefix (e.g., /c/path/to/file): $1"
  path="${input}"
  object_path="${path:2}"
else
  # Relative path
  echo "Relative path: $1"
  cd $pwd
  path="$(realpath "$1")"
  object_path="${path:2}"
fi

export imgnx_normalized_path_full_path
export imgnx_normalized_path_object_path

exit 0
