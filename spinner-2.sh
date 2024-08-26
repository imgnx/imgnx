# # Spinner...
# spinner() {
# 	local pid=$1
# 	local delay=0.1
# 	local spinstring='|/-\'
# 	while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
# 		local temp=${spinstring#?}
# 		printf " [%c]  " "$spinstring"
# 		local spinstring=$temp${spinstring%"$temp"}
# 		sleep $delay
# 		printf "\b\b\b\b\b\b"
# 	done
# 	printf "    \b\b\b\b"
# }

# # Start spinner...
# echo -e "Calculating hash..."
# spinner $!
# End spinner...
