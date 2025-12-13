
if command -v zypper &> /dev/null ; then
	CMD=(
		sudo zypper in -y
			pamixer # Audio stufff
			playerctl # MORREEE AUDIO STUFFFF
			pavucontrol # Audio controls
			SwayNotificationCenter # Notifications!
			brightnessctl # For...
	)
	"${CMD[@]}"
fi

notify-send "Finished Installing!" -a "sway.sh"
