#!/bin/bash
# Adjust border and titlebar dynamically for tiling/floating windows
# - floating: titlebar true, border 1
# - tiling: titlebar false, border 2

# Subscribe to window changes
swaymsg -m -t subscribe '["window"]' --raw \
	| jq \
		--unbuffered \
		-c 'select(.change == "floating") | {id: .container.id, type: .container.type}' \
	| while read -r obj; do
		con_id=$(jq -r '.id' <<< "$obj")
		con_type=$(jq -r '.type' <<< "$obj")
		if [[ $con_type == "floating_con" ]]; then # Floating
			swaymsg "[con_id=$con_id]" border normal
		else # Tiling
			swaymsg "[con_id=$con_id]" border none
		fi
	done &
