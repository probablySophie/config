
if command -v flatpak &> /dev/null ; then
	CMD=(
		flatpak install -y flathub
		com.github.tchx84.Flatseal # Flatseal for flatpak permissions management
		org.darktable.Darktable # Image management
		org.gnome.Boxes # Boxes for VM management
		org.inkscape.Inkscape # Inkscape for SVG editing
		org.kde.kdenlive # Kdenlive for video editing
		org.libreoffice.LibreOffice # LibreOffice as an office suite
		org.mozilla.Thunderbird # Thunderbird for emails
		org.mozilla.firefox # Firefox for internet
		org.gimp.GIMP # Image editing :)
	)
	"${CMD[@]}"
fi

notify-send "Finished Installing!" -a "flatpak.sh"
