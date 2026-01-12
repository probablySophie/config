# Things wanted/needed for sway

if command -v zypper &> /dev/null ; then
	CMD=(
		sudo zypper in -y
			pavucontrol # Audio controls
			pamixer # Audio level controls for Pulse Audio
			playerctl # Command-line utility for controlling (multiple) music players
			mpd # Music player daemon
			SwayNotificationCenter # Notifications!
			brightnessctl # For...
	)
	"${CMD[@]}"
fi

# TODO: Do we actually need both pavucontrol and pamixer?  They appear to both do the same thing.

notify-send "Finished Installing!" -a "sway.sh"
