# https://git-scm.com/book/fa/v2/Git-Internals-Git-Objects#:~:text=%24%20find%20.git/objects%20%2Dtype%20f%0A.git,cat%2Dfile%20%2Dp%20d670460b4b4aece5915caf5c68d12f560a9fe3e4%0Atest%20content
# $ find .git/objects -type f
# .git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
# If you again examine your objects directory, you can see that it now contains a file for that new content. This is how Git stores the content initially — as a single file per piece of content, named with the SHA-1 checksum of the content and its header. The subdirectory is named with the first 2 characters of the SHA-1, and the filename is the remaining 38 characters.
# Once you have content in your object database, you can examine that content with the git cat-file command. This command is sort of a Swiss army knife for inspecting Git objects. Passing -p to cat-file instructs the command to first figure out the type of content, then display it appropriately:
# $ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
# test content

# In this example, 1f is the folder in ./.git/objects and the rest is the filename.

# cd /i/.git/objects && ls -at | head | ls -at | head | grep -E '[0-9a-f]$' |
#   ls -- | grep -E '[0-9a-f]$' | sed -r 's/ //g' | awk ' { system("git cat-file -p 1f" $1) } '

# local dir file
# cd "$GIT_OBJECTS_DIR" || {
#   printf "Failed to change directory to %s\n" "$GIT_OBJECTS_DIR" >&2
#   return 1
# }

# echo "Reading Git objects from $GIT_OBJECTS_DIR"

# # Loop through each directory that matches the pattern of Git object directories

pwd=$(pwd)

git_obj_dir="$(git rev-parse --git-dir)/objects"
git_obj_dir="$(normalize_path -b $git_obj_dir)"

echo "Reading Git objects from $git_obj_dir"

if [[ $git_obj_dir =~ \" ]]; then
  if [[ $git_obj_dir =~ ^\"(.*)\"[[:space:]]\"(.*)\"$ ]]; then
    git_obj_dir="${BASH_REMATCH[1]}"
  fi
else
  if [[ $git_obj_dir =~ (.*)[[:space:]](.*) ]]; then
    git_obj_dir="${BASH_REMATCH[1]}"
  fi
fi
if [[ "$git_obj_dir" == "" ]]; then
  echo -e "${DEEP_RED}Read Error: Bad path for directory $input${R} 😔"
  exit 1
fi

echo $git_obj_dir

# echo "$(ls $git_obj_dir -t | head)"

cd "$git_obj_dir" || {
  printf "Failed to change directory to %s\n" "$git_obj_dir" >&2
  exit 1
}

# Loop through each directory that matches the pattern of Git object directories
for dir in $(ls $git_obj_dir -t 2>/dev/null | head); do
  cd "$git_obj_dir/$dir" || {
    printf "Failed to change directory to %s\n" "$dir" >&2
    exit 1
  }
  echo "DIR: " $dir
  # Loop through each file inside the directory
  for file in "$dir"/*; do
    if [[ -f $file ]]; then
      echo "%s%s" "$dir" "$(basename "$file")" | xargs git cat-file -p
    fi
  done
done
