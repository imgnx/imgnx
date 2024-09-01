Add a progress bar...
progress_bar() {
  local duration=$1
  local interval=0.1
  local total_width=40
  local elapsed_width=0
  local progress=""
  local percent=0
  local elapsed=0
  local chars=""
  local spinner_index=0
  local spinner_chars='|/-\'
  while [ $elapsed -le $duration ]; do
    elapsed=$(bc <<<"$elapsed + $interval")
    percent=$(bc <<<"scale=2; $elapsed / $duration * 100")
    elapsed_width=$(bc <<<"scale=0; $percent / 100 * $total_width")
    chars=$(printf "%0.s=" $(seq 1 $elapsed_width))
    spinner_index=$(((spinner_index + 1) % 4))
    spinner_char=${spinner_chars:$spinner_index:1}
    progress="\r[$chars>$spinner_char] $percent%%"
    printf "%s" "$progress"
    sleep $interval
  done
  printf "\n"
}

Call progress bar function...
echo -e "Processing..."
duration=10 # Set the duration of the progress bar in seconds
progress_bar $duration
