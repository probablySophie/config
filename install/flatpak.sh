flatpak install flathub \
	
if command -v flatpak &> /dev/null ; then
	CMD=(
		zypper install
		com.github.tchx84.Flatseal # Flatseal for flatpak permissions management
		org.darktable.Darktable # Image management
		org.gnome.Boxes # Boxes for VM management
		org.inkscape.Inkscape # Inkscape for SVG editing
		org.kde.kdenlive # Kdenlive for video editing
		org.libreoffice.LibreOffice # LibreOffice as an office suite
		org.mozilla.Thunderbird # Thunderbird for emails
		org.mozilla.firefox # Firefox for internet
	)
	"${CMD[@]}"
fi

notify-send "Finished Installing!" -a "zypper.sh"
