#!/bin/bash

{

	AMBER="\e[38;5;227m"
	AWESOME="\e[38;5;202m"
	BLACK="\e[30m"
	BLUE="\e[38;5;20m"
	BOLD="\e[1m"
	CERISE="\e[38;5;161m"
	CHARTREUSE="\e[38;5;118m"
	CYAN="\e[36m"
	CYBERPUNK="\e[38;5;198m"
	DEEP_MAGENTA="\e[38;5;164m"
	DEEP_RED="\e[38;5;196m"
	DEEP_PINK="\e[38;5;198m"
	DEEP_PURPLE="\e[38;5;57m"
	DEADED="\e[38;5;135m"
	DIM="\e[2m"
	EGGPLANT="\e[38;5;99m"
	FERRARI_RED="\e[38;5;196m"
	GREEN="\e[32m"
	HARD_ISH_PINK="\e[38;5;200m"
	HELIOTROPE="\e[38;5;171m"
	HOT_PINK="\e[38;5;205m"
	ILLICIT_PURPLE="\e[38;5;56m"
	CORNFLOWER_BLUE="\e[38;5;62m"
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
	RESET="\e[0m"
	RED_ORANGE="\e[38;5;208m"
	ROSE="\e[38;5;170m"
	PINK="\e[38;5;206m"
	PEARL="\e[38;5;231m"
	SILVER="\e[38;5;247m"
	UFO_GREEN="\e[38;5;84m" # UFO Green (#84) - https://en.wikipedia.org/wiki/Shades_of_green#UFO_green
	VIOLETS_ARE_BLUE="\e[38;5;57m"
	YELLOW="\e[33m"
	WHITE="\e[97m"
	WHITESMOKE="\e[38;5;7m"

	STRAWBERRY="\e[38;5;203m"
	# BKGD_STRAWBERRY="\e[48;5;203m"

	# BKGD_BLURRY_PURPLE_PINK_ROSE="\e[48;5;125;38;5;251m"
	BKGD_CYBERPUNK="\e[48;5;198m"
	# BKGD_DEEP_PURPLE="\e[48;5;57m"
	# BKGD_DARK_PURPLE="\e[48;5;53m"
	# BKGD_EGGPLANT="\e[48;5;99m"
	# BKGD_HELIOTROPE="\e[48;5;171m"
	# BKGD_MAGENTA="\e[45m"
	# BKGD_PERSIAN_RED="\e[48;5;204m"
	# BKGD_PERSIAN_INDIGO="\e[48;5;75m"
	# BKGD_ROSE="\e[48;5;251m"
	# BKGD_TRANSPARENT_ILLICIT_PURPLE="\e[48;5;56;38;5;0m"
	# BKGD_VIOLETS_ARE_BLUE="\e[48;5;145m"
	# BKGD_WHITE="\e[107m"
	BKGD_BLACK="\e[40m"
}

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
echo -e "${BOLD}${DIM}${ROSE}${BKGD_CYBERPUNK}(${BOLD}${WHITE}r${BKGD_CYBERPUNK}${BOLD}${WHITE}e${RESET}${AMBER}${BOLD}:${RESET}${PEACH}I${ROSE}M${DEEP_MAGENTA}G${DIM}${ILLICIT_PURPLE}N${EGGPLANT}X${MIDNIGHT_EXPRESS})${DIM}...${RESET}${BOLD}${WHITE}${BKGD_BLACK} bash.${RESET}"
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
echo -e "${RESET}${BOLD}(R)emote${DIM}:....${RESET}${PACMAN}gs://imgfunnels.com$path_without_drive${RESET}"
echo -e "${RESET}${BOLD}(L)ocal${DIM}:.....${RESET}${BOLD}${MS_PACMAN_KISS_PINK}/i$path_without_drive${RESET}"
echo -e "Is this correct?"
echo -en "${DIM}Press Enter to continue:"
read -p ""
echo -e "Checking integrity of ${RESET}$input..."
echo -e "${DIM}Generating Crc/Md5 chec${CYAN}k${UFO_GREEN}s${CHARTREUSE}u${AMBER}m${ORANGE}.${RED}.${DEEP_RED}.${RESET}"

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
		echo -e "Processed: ${YELLOW}$line${RESET}"
		if [[ "$line" =~ Hash\ \(crc32c\):([[:space:]]*[A-Za-z0-9+/=]{8}[[:space:]]?)$ ]]; then
			crc32c=$(echo "${BASH_REMATCH[1]}" | tr -d '[:space:]') #
			crc32c_decoded=$(echo $crc32c | base64 --decode | xxd -p)
			echo "Waiting..."
			result=$(node $SCRIPT_DIR/replace_text.mjs "$line" "$crc32c" "\e[0m\e[1m\e[32m$crc32c\e[0m\e[2m")
			echo "Result: $result"
			echo -e "${DIM}$result${RESET}" >>$temp_file
		elif [[ "$line" =~ Hash\ \(md5\):([[:space:]]*[A-Za-z0-9+/=]{24}[[:space:]]?)$ ]]; then
			md5=$(echo "${BASH_REMATCH[1]}" | tr -d '[:space:]')
			md5_decoded=$(echo $md5 | base64 --decode | xxd -p)
			echo "Waiting..."
			result=$(node $SCRIPT_DIR/replace_text.mjs "$line" "$md5" "\e[0m\e[1m\e[32m$md5\e[0m\e[2m")
			echo "Result: $result"
			echo -e "${DIM}$result${RESET}" >>$temp_file
		else
			echo -e "${DIM}$line${RESET}" >>$temp_file
		fi
	done
	echo "After processing..."
	echo -e "Processed: ${YELLOW}CRC32C:	$crc32c${RESET}"
	echo -e "Processed: ${YELLOW}MD5:	$md5${RESET}"
	cat $temp_file
	rm $temp_file
}

checklines "${lines[@]}"

# Store variabels from the previous run...
crc32c_checksum=$crc32c
md5_checksum=$md5

# Validate...
if [[ "$crc32c_checksum" == "" ]]; then
	echo -e "${RED}Crc32c Checksum not found!${RESET}"
	exit 1
fi
if [[ "$md5_checksum" == "" ]]; then
	echo -e "${RED}Md5 Checksum not found!${RESET}"
	exit 1
fi

echo -e "${BOLD}${WHITESMOKE}R${SILVER}e${RESET}${DIM}making temp file..."

temp_file=$(mktemp)
crc32c=""
md5=""
output=""
lines=""

echo -e "Calculating ${CYAN}h${UFO_GREEN}a${CHARTREUSE}s${AMBER}h${ORANGE}.${RED}.${DEEP_RED}.${RESET}"

output=$(gsutil hash $input)
mapfile -t lines < <(echo -e "$output")
checklines "${lines[@]}"
crc32c_hash=$crc32c
md5_hash=$md5
echo -e "Processing complete."
# echo -e "${BKGD_BLACK}${WHITE}crc32c: $crc32c_hash${RESET}"
# echo -e "${BKGD_BLACK}${WHITE}md5: $md5_hash${RESET}"

{
	if [[ "$crc32c_hash" != "" &&
		"$crc32c_hash" == "$crc32c_checksum" &&
		"$md5_hash" != "" &&
		"$md5_hash" == "$md5_checksum" ]] \
		; then
		echo -e "${BKGD_BLACK}${PEARL}${BOLD}Crc32c Checksum/Hash: ${RESET}${BKGD_BLACK}${UFO_GREEN}$crc32c_hash${RESET}"
		echo -e "${MIDNIGHT_EXPRESS}${BOLD}Decoded: ${RESET}$crc32c_decoded${RESET}"
		echo -e "${BKGD_BLACK}${PEARL}${BOLD}Md5 Checksum/Hash:${RESET}${BKGD_BLACK}${UFO_GREEN}    $md5_hash${RESET}"
		echo -e "${MIDNIGHT_EXPRESS}${BOLD}Decoded: ${RESET}$md5_decoded${RESET}"
		echo -e "${PURPLE}${BOLD}🛸 🎸 Match! 🍄 👽${RESET}"
		exit 0
	else
		echo -e "${DEEP_RED}🤔 Integrity check failed! 💩${RESET}"
		if [[ "$crc32c_hash" == "" ]]; then
			echo -e "${DEEP_RED}Crc32c hash not found!${RESET}"
			echo -e "${WHITE}Crc32c Checksum: $crc32c_checksum${RESET}"
			echo -e "${WHITE}Crc32c Hash: $crc32c_hash${RESET}"
			exit 1
		fi
		if [[ "$md5_hash" == "" ]]; then
			echo -e "${DEEP_RED}md5 hash not found!${RESET}"
			echo -e "${WHITE}Md5 Checksum: $md5_checksum${RESET}"
			echo -e "${WHITE}Md5 Hash: $md5_hash${RESET}"
			exit 1
		fi
		if [[ "$crc32c_hash" != "$crc32c" ]]; then
			echo -e "${DEEP_RED}Crc32c hash mismatch!${RESET}"
			echo -e "${WHITE}Crc32c Checksum: $crc32c_checksum${RESET}"
			echo -e "${WHITE}Crc32c Hash: $crc32c_hash${RESET}"
			exit 1
		fi
		if [[ "$md5_hash" != "$md5" ]]; then
			echo -e "${DEEP_RED}md5 hash mismatch!${RESET}"
			echo -e "${WHITE}Md5 Checksum: $md5_checksum${RESET}"
			echo -e "${WHITE}Md5 Hash: $md5_hash${RESET}"
			exit 1
		fi
	fi

}
