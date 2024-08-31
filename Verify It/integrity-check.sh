#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
echo "BASH_SOURCE[0]: ${BASH_SOURCE[0]}"

PWD=$(pwd)
cd "$SCRIPT_DIR"
cd ../bash
. colors.sh
cd $PWD

# Function to display spinner
spinner() {
	local pid=$!
	# local delay=0.1
	# local spinstring='|/-\'
	local spinstring='    '

	function cleanup() {
		# echo "Spinner cleanup..."
		tput cnorm
	}

	trap cleanup EXIT

	tput civis

	while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
		# echo "Spinner start..."
		local temp=${spinstring#?}
		printf " [%c]  " "$spinstring"
		local spinstring=$temp${spinstring%"$temp"}
		sleep $delay
		printf "\r"
	done
	printf "    \r"
}

# Init...
cd "$(dirname "$0")"
SCRIPT_DIR="$(pwd)"
crc32c=""
md5=""
output=""
lines=""

# (re:IMGNX)...bash.
echo -e "${B}${D}${ROSE}${BKGD_CYBERPUNK}(${B}${WHITE}r${BKGD_CYBERPUNK}${B}${WHITE}e${R}${AMBER}${B}:${R}${PEACH}I${ROSE}M${DEEP_MAGENTA}G${D}${ILLICIT_PURPLE}N${EGGPLANT}X${MIDNIGHT_EXPRESS})${D}...${R}${B}${WHITE}${BKGD_BLACK} bash.${R}"
# https://cloud.google.com/storage/docs/resumable-uploads#integrity_checks
if [ $# -eq 0 ]; then
	echo -e "Usage: \`integrity-check <file>\`"
	echo -e "Please enter the path to the file to check:"
	read input
else
	input=$1
fi

# Path...
path_without_drive="${input:2}"

# Check...
echo -e "${R}${B}(R)emote${D}:....${R}${PACMAN}gs://imgfunnels.com$path_without_drive${R}"
echo -e "${R}${B}(L)ocal${D}:.....${R}${B}${MS_PACMAN_KISS_PINK}/i$path_without_drive${R}"
echo -e "Is this correct?    "
echo -en "${D}Press Enter to continue:"
read -p ""
echo -e "Checking integrity of ${R}$input..."
echo -e "${D}Generating Crc/Md5 chec${CYAN}k${UFO_GREEN}s${CHARTREUSE}u${AMBER}m${ORANGE}.${RED}.${DEEP_RED}.${R}"

# Temp file...
temp_file=$(mktemp)

# Mapping...
output=$(gsutil stat "gs://imgfunnels.com$path_without_drive" 2>&1)
mapfile -t lines < <(echo -e "$output")

# Recursive Function _ Check lines...
function checklines() {
	local lines=("$@")
	if [ "${#lines[@]}" -gt "1" ]; then
		echo "Payload is an Array of ${#lines[@]} elements"
	else
		echo "Payload is NOT an Array"
	fi
	# Debugger
	count=${#lines[@]}
	for line in "${lines[@]}"; do
		# Debugger
		echo -e "Processed: ${YELLOW}$line${R}"
		if [[ "$line" =~ Hash\ \(crc32c\):([[:space:]]*[A-Za-z0-9+/=]{8}[[:space:]]?)$ ]]; then
			crc32c=$(echo "${BASH_REMATCH[1]}" | tr -d '[:space:]') #
			crc32c_decoded=$(echo $crc32c | base64 --decode | xxd -p)
			echo "Waiting..."
			result=$(node $SCRIPT_DIR/replace_text.mjs "$line" "$crc32c" "\e[0m\e[1m\e[32m$crc32c\e[0m\e[2m")
			echo "Result: $result"
			echo -e "${D}$result${R}" >>$temp_file
		elif [[ "$line" =~ Hash\ \(md5\):([[:space:]]*[A-Za-z0-9+/=]{24}[[:space:]]?)$ ]]; then
			md5=$(echo "${BASH_REMATCH[1]}" | tr -d '[:space:]')
			md5_decoded=$(echo $md5 | base64 --decode | xxd -p)
			echo "Waiting..."
			result=$(node $SCRIPT_DIR/replace_text.mjs "$line" "$md5" "\e[0m\e[1m\e[32m$md5\e[0m\e[2m")
			echo "Result: $result"
			echo -e "${D}$result${R}" >>$temp_file
		else
			echo -e "${D}$line${R}" >>$temp_file
		fi
	done
	echo "After processing..."
	echo -e "Processed: ${YELLOW}CRC32C:	$crc32c${R}"
	echo -e "Processed: ${YELLOW}MD5:	$md5${R}"
	cat $temp_file
	rm $temp_file
}

checklines "${lines[@]}"

# Store variabels from the previous run...
crc32c_checksum=$crc32c
md5_checksum=$md5

# Validate...
if [[ "$crc32c_checksum" == "" ]]; then
	echo -e "${RED}Crc32c Checksum not found!${R}"
	exit 1
fi
if [[ "$md5_checksum" == "" ]]; then
	echo -e "${RED}Md5 Checksum not found!${R}"
	exit 1
fi

echo -e "${B}${WHITESMOKE}R${SILVER}e${R}${D}making temp file..."

temp_file=$(mktemp)
crc32c=""
md5=""
output=""
lines=""

echo -e "Calculating ${CYAN}h${UFO_GREEN}a${CHARTREUSE}s${AMBER}h${ORANGE}.${RED}.${DEEP_RED}.${R}"

output=$(gsutil hash $input)
mapfile -t lines < <(echo -e "$output")
checklines "${lines[@]}"
crc32c_hash=$crc32c
md5_hash=$md5
echo -e "Processing complete."
# echo -e "${BKGD_BLACK}${WHITE}crc32c: $crc32c_hash${R}"
# echo -e "${BKGD_BLACK}${WHITE}md5: $md5_hash${R}"

{
	if [[ "$crc32c_hash" != "" &&
		"$crc32c_hash" == "$crc32c_checksum" &&
		"$md5_hash" != "" &&
		"$md5_hash" == "$md5_checksum" ]] \
		; then
		echo -e "${BKGD_BLACK}${PEARL}${B}Crc32c Checksum/Hash: ${R}${BKGD_BLACK}${UFO_GREEN}$crc32c_hash${R}"
		echo -e "${BKGD_BLACK}${MIDNIGHT_EXPRESS}${B}Decoded: ${R}${BKGD_BLACK}$crc32c_decoded${R}"
		echo -e "${BKGD_BLACK}${PEARL}${B}Md5 Checksum/Hash:${R}${BKGD_BLACK}${UFO_GREEN}    $md5_hash${R}"
		echo -e "${BKGD_BLACK}${MIDNIGHT_EXPRESS}${B}Decoded: ${R}${BKGD_BLACK}$md5_decoded${R}"
		echo -e "${BKGD_BLACK}${PURPLE}${B}🛸 🎸 Match! 🍄 👽${R}"
		exit 0
	else
		echo -e "${DEEP_RED}🤔 Integrity check failed! 💩${R}"
		if [[ "$crc32c_hash" == "" ]]; then
			echo -e "${DEEP_RED}Crc32c hash not found!${R}"
			echo -e "${WHITE}Crc32c Checksum: $crc32c_checksum${R}"
			echo -e "${WHITE}Crc32c Hash: $crc32c_hash${R}"
			exit 1
		fi
		if [[ "$md5_hash" == "" ]]; then
			echo -e "${DEEP_RED}md5 hash not found!${R}"
			echo -e "${WHITE}Md5 Checksum: $md5_checksum${R}"
			echo -e "${WHITE}Md5 Hash: $md5_hash${R}"
			exit 1
		fi
		if [[ "$crc32c_hash" != "$crc32c" ]]; then
			echo -e "${DEEP_RED}Crc32c hash mismatch!${R}"
			echo -e "${WHITE}Crc32c Checksum: $crc32c_checksum${R}"
			echo -e "${WHITE}Crc32c Hash: $crc32c_hash${R}"
			exit 1
		fi
		if [[ "$md5_hash" != "$md5" ]]; then
			echo -e "${DEEP_RED}Md5 hash mismatch!${R}"
			echo -e "${WHITE}Md5 Checksum: $md5_checksum${R}"
			echo -e "${WHITE}Md5 Hash: $md5_hash${R}"
			exit 1
		fi
	fi

}
