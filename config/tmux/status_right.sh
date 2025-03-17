function displaytime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  (( $D > 0 )) && printf '%dd ' $D
  (( $H > 0 )) && printf '%dh ' $H
  (( $M > 0 )) && printf '%dm ' $M
  printf '%ds' $S
}

printf "up:($(displaytime $(tmux display -p "#{e|-|:%s,#{session_created}}"))) $(TZ=$TZ date +'%-l:%M%P %Y-%m-%d')"
