#!/bin/bash

RED="\e[31m"
CYAN="\e[38;5;84m" # UFO Green (#84) - https://en.wikipedia.org/wiki/Shades_of_green#UFO_green
BLUE="\e[38;5;20m"
YELLOW="\e[33m"
MAGENTA="\e[35m"
GREEN="\e[32m"
BOLD="\033[1;33"
PURPLE="\e[38;5;129m"
RESET="\e[0m"
DIM="\e[2m"

cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"

echo -e "${CYAN}(RE)IMGNX: ${RED}bash${RESET}"
# https://cloud.google.com/storage/docs/resumable-uploads#integrity_checks
if [ $# -eq 0 ]; then
	echo -e "Usage: \`integrity-check <file>\`"
	echo -e "Please enter the path to the file to check:"
	read input
else
	input=$1
fi

path_without_drive="${input:2}"

echo -e "Remote:  ${YELLOW}gs://imgfunnels.com$path_without_drive${RESET}"
echo -e "Local: ${BLUE}/i$path_without_drive${RESET}"
echo -e "Is this correct?"
read -p "Press Enter to continue:"
echo -e "Checking integrity of $input..."

# Execute gsutil hash command and capture the output into the lines array
output=$(gsutil stat "gs://imgfunnels.com$path_without_drive" 2>&1)
mapfile -t lines < <(echo -e "$output")

temp_file=$(mktemp)

for line in "${lines[@]}"; do
	if [[ "$line" =~ Hash\ \(crc32c\):([[:space:]]*[A-Za-z0-9+/=]{8}[[:space:]]?)$ ]]; then
		crc32c=$(echo "${BASH_REMATCH[1]}" | tr -d '[:space:]') # 		# crc32c_decoded=$(echo $crc32c | base64 --decode | xxd -p)
		# python $SCRIPT_DIR/replace_text.py "$temp_file" "$crc32c" "\e[0m\e[32m$crc32c\e[0m\e[2m"
		echo "Waiting..."
		result=node $SCRIPT_DIR/replace_text.mjs "$line" "$crc32c" "\e[0m\e[32m$crc32c\e[0m\e[2m"
		# echo "Result: $result"
		echo -e "${DIM}$result${RESET}" >>$temp_file
	elif [[ "$line" =~ Hash\ \(md5\):([[:space:]]*[A-Za-z0-9+/=]{24}[[:space:]]?)$ ]]; then
		md5=$(echo "${BASH_REMATCH[1]}" | tr -d '[:space:]') # md5_decoded=$(echo $md5 | base64 --decode | xxd -p)
		# python $SCRIPT_DIR/replace_text.py "$temp_file" "$md5" "\e[0m\e[32m$md5\e[0m\e[2m"
		echo "Waiting..."
		result=$(node $SCRIPT_DIR/replace_text.mjs "$line" "$md5" "\e[0m\e[32m$md5\e[0m\e[2m")
		# echo "Result: $result"
		echo -e "${DIM}$result${RESET}" >>$temp_file
	else
		echo -e "${DIM}$line${RESET}" >>$temp_file
	fi
done

echo "After processing..."
cat $temp_file
rm $temp_file

if [[ "$crc32c" == "" ]]; then
	echo -e "${RED}Crc32c Checksum not found!${RESET}"
	exit 1
fi
if [[ "$md5" == "" ]]; then
	echo -e "${RED}Md5 Checksum not found!${RESET}"
	exit 1
fi

echo "Remaking temp file..."

temp_file=$(mktemp)
echo gsutil hash "$input" >>temp_file

# Capture the lines that contain the hash values
mapfile -t lines < <(echo -e "$output" | grep -E "Hash \(crc32c\)|Hash \(md5\)")

# Extract the hash values from the lines
for line in "${lines[@]}"; do
	# Debugger
	# echo -e "${CYAN}LOCAL 1: $line${RESET}"
	echo -e "${RED}($crc32c)/\1/gm"
	echo -e "${RED}($md5)/\1/gm"

	crc32c_hash=$(echo $line | grep -E "$crc32c" | sed -r "$crc32c")
	md5_hash=$(echo $line | grep -E "$md5" | sed -r "$md5")
done

# Match and highlight the checksums
output=$(echo -e "$output" | sed -r "s/($crc32c|$md5)/${BOLD}${YELLOW}\1${RESET}/g")
echo -e "$output"

# Debugger
# for line in "${lines[@]}"; do
# 	echo -e "${BLUE}LINE (L): $line${RESET}"
# done

if [[ "$crc32c_hash" != "" &&
	"$crc32c_hash" == "$crc32c" &&
	"$md5_hash" != "" &&
	"$md5_hash" == "$md5" ]] \
	; then
	echo -e "${GREEN}Crc32c Checksum: $crc32c${RESET}"
	echo -e "${CYAN}Crc32c Hash:${RESET} $crc32c_hash"
	echo -e "${GREEN}Md5 Checksum: $md5${RESET}"
	echo -e "${CYAN}Md5 Hash:${RESET} $md5_hash"
	echo -e "${CYAN}Match!${RESET}"
	exit 0
else
	if [[ "$crc32c_hash" == "" ]]; then
		echo -e "${RED}Crc32c hash not found!${RESET}"
		echo -e "${GREEN}Crc32c Checksum: $crc32c${RESET}"
		echo -e "${GREEN}Crc32c Hash: $crc32c_hash${RESET}"
		exit 1
	fi
	if [[ "$md5_hash" == "" ]]; then
		echo -e "${RED}md5 hash not found!${RESET}"
		echo -e "${GREEN}Md5 Checksum: $md5${RESET}"
		echo -e "${GREEN}Md5 Hash: $md5_hash${RESET}"
		exit 1
	fi
	if [[ "$crc32c_hash" != "$crc32c" ]]; then
		echo -e "${RED}Crc32c hash mismatch!${RESET}"
		echo -e "${GREEN}Crc32c Checksum: $crc32c${RESET}"
		echo -e "${GREEN}Crc32c Hash: $crc32c_hash${RESET}"
		exit 1
	fi
	if [[ "$md5_hash" != "$md5" ]]; then
		echo -e "${RED}md5 hash mismatch!${RESET}"
		echo -e "${GREEN}Md5 Checksum: $md5${RESET}"
		echo -e "${GREEN}Md5 Hash: $md5_hash${RESET}"
		exit 1
	fi
fi
