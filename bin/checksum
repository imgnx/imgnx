#!/bin/bash

crc32c=""
md5=""
output=""
lines=""
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# echo "BASH_SOURCE[0]: ${BASH_SOURCE[0]}"
pwd=$(pwd)
# echo "pwd: $pwd"

cd "$SCRIPT_DIR"

if [ -f "./colors.sh" ]; then
	cd ../bin
	. ./colors.sh
	cd $pwd
fi

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

# (re:IMGNX)...bash.
echo -e "${B}${D}${I}${ROSE}${BKGD_CYBERPUNK}(${B}${WHITE}r${BKGD_CYBERPUNK}${B}${WHITE}e${R}${AMBER}${B}:${R}${PEACH}I${ROSE}M${DEEP_MAGENTA}G${D}${ILLICIT_PURPLE}N${EGGPLANT}X${MIDNIGHT_EXPRESS})${D}   ${R}${B}${WHITE}${BKGD_BLACK} bash.${R}"
# https://cloud.google.com/storage/docs/resumable-uploads#integrity_checks

if [ $# -eq 0 ]; then
	echo -e "Usage: \`integrity-check <file>\`"
	echo -e "Please enter the path to the file to check:"
	read input
else
	input=$1
fi

paths="$(normalize_path -q $input)"

# echo -e "Paths: $paths"
if [[ $paths =~ \" ]]; then
	# echo "Path has a space in it."
	if [[ $paths =~ ^\"(.*)\"[[:space:]]\"(.*)\"$ ]]; then
		full_path="${BASH_REMATCH[1]}"
		object_path="${BASH_REMATCH[2]}"
	fi
else
	# echo "Path does not have a space in it."
	if [[ $paths =~ (.*)[[:space:]](.*) ]]; then
		full_path="${BASH_REMATCH[1]}"
		object_path="${BASH_REMATCH[2]}"
	fi
fi

if [[ "$full_path" == "" || "$object_path" == "" ]]; then
	if [[ $input =~ (\\$)(\/$)(\.{0}) ]]; then
		echo -e "${MAGENTA} ::pensive:: ${MAGENTA}${DEEP_RED}Read Error: Could not find directory $input${R}"
	else
		echo -e "${MAGENTA} ::pensive:: ${MAGENTA}${DEEP_RED}Read Error: Could not find file $input${R}"
	fi
	exit 1
fi

# echo "Full (normalized) path: $full_path"
# echo "Object path: $object_path"

# Check...
echo -e "${D}First, we need the ${R}path...${R}"
echo -e "${D}Does this look right?${R}"
echo
echo -e "${R}${B}Loc${D}al:     ${R}${B}${PACMAN}$full_path${R}"
echo -e "${R}${B}Rem${D}ote:    ${MS_PACMAN_KISS_PINK}gs://imgfunnels.com${N}${B}$object_path${R}"
echo
echo -en "${D}Press [Enter] to confirm:${R}"
read -p ""
echo -e "${D}Checking integrity of ${R}$input..."
echo -e "${D}Generating Crc/Md5 chec${CYAN}k${UFO_GREEN}s${CHARTREUSE}u${AMBER}m${ORANGE}.${RED}.${DEEP_RED}.${R}"

# Mapping...
output=$(gsutil stat "gs://imgfunnels.com$object_path" 2>&1)
mapfile -t lines < <(echo -e "$output")
temp_file=""

# Recursive Function _ Check lines...
function checklines() {

	temp_file=$(mktemp) || {
		echo -e "${DEEP_RED}Error: $!${R}"
		exit 1
	}

	if ! [ -f "$temp_file" ]; then
		echo -e "${DEEP_RED}Error: $!${R}"
		exit 1
	fi

	local lines=("$@")

	echo -e "${B}${WHITESMOKE}R${SILVER}e${R}${D}making temp file..."

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
			crc32c=$(echo "${BASH_REMATCH[1]}" | tr -d '[:space:]')
			echo "CRC 1: $crc32c"
			crc32c_decoded=$(echo $crc32c | base64 --decode | xxd -p)
			echo "Waiting..."
			result=$(node "$SCRIPT_DIR/replace_text.mjs" "$line" "$crc32c" "\e[0m\e[1m\e[32m$crc32c\e[0m\e[2m")
			# echo "Result: $result"
			echo -e "${D}$result${R}" >>$temp_file
		elif [[ "$line" =~ Hash\ \(md5\):([[:space:]]*[A-Za-z0-9+/=]{24}[[:space:]]?)$ ]]; then
			md5=$(echo "${BASH_REMATCH[1]}" | tr -d '[:space:]')
			echo "MD5 1: $md5"
			md5_decoded=$(echo $md5 | base64 --decode | xxd -p)
			echo "Waiting..."
			result=$(node "$SCRIPT_DIR/replace_text.mjs" "$line" "$md5" "\e[0m\e[1m\e[32m$md5\e[0m\e[2m")
			# echo "Result: $result"
			echo -e "${D}$result${R}" >>$temp_file
		else
			echo -e "${D}$line${R}" >>$temp_file
		fi
	done
	echo "After processing..."
	echo -e "Processed: ${YELLOW}CRC32C:	$crc32c${R}"
	echo -e "Processed: ${YELLOW}MD5:	$md5${R}"
	# End of Try

	cat $temp_file
	rm $temp_file
	# End of Finally
}

if ! checklines "${lines[@]}"; then
	echo -e "${DEEP_RED}Error: $!${R}"
	rm $temp_file
	exit 1
fi

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

crc32c=""
md5=""
output=""
lines=""

echo -e "Calculating ${CYAN}h${UFO_GREEN}a${CHARTREUSE}s${AMBER}h${ORANGE}.${RED}.${DEEP_RED}.${R}"

output=$(gsutil hash "$full_path" 2>&1)
mapfile -t lines < <(echo -e "$output")

if ! checklines "${lines[@]}"; then
	echo -e "${DEEP_RED}Error: $!${R}"
	rm $temp_file
	exit 1
fi

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
		echo -e "${BKGD_BLACK}${PURPLE}${B}🍄 It's a match! 💩${R}"
		exit 0
	else
		echo -e "${MAGENTA} ::thinking:: ${DEEP_RED} Integrity check failed!${R}"
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
