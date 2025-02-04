#!/bin/bash

"$@" &

LOADING_DISPLAY=(".  " ".. " "...")
LOADING_COUNT=0

while kill -0 $! &> /dev/null
do
    printf " ${LOADING_DISPLAY[$LOADING_COUNT]} \r" > /dev/tty
    sleep 0.5

    LOADING_COUNT=$((LOADING_COUNT+1));
    if [ "$LOADING_COUNT" -ge "${#LOADING_DISPLAY[@]}" ]; then
        LOADING_COUNT=0
    fi
done

printf '\n' > /dev/tty
