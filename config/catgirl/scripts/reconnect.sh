#!/bin/sh
set -u

# From: https://git.causal.agency/catgirl/tree/scripts/reconnect.sh

while :; do
	catgirl "$@"
	status=$?
	if [ $status -ne 69 ]; then
		exit $status
	fi
done

