# Audacity (app image) https://www.audacityteam.org/download/
# Blender3D (tarball) https://www.blender.org/download/
# Zotero (tarball) https://www.zotero.org/download/
# Hack Nerd Font https://www.nerdfonts.com/font-downloads
# Picotron! https://www.lexaloffle.com/picotron.php (needs a desktop file)

# Obsidian - Flatpak https://flathub.org/en/apps/md.obsidian.Obsidian
# Podman desktop! io.podman_desktop.PodmanDesktop

mkdir -p ~/.local/completions

# More zypper stuff!
if command -v zypper &> /dev/null ; then
	CMD=(
		sudo zypper in -y
			lazygit # For git!
			kdeconnect-kde # KDE Connect
			lua-language-server # Lua
			lua55 # Lua
	)
	"${CMD[@]}"
fi

# Bun - JavaScript runtime
curl -fsSL https://bun.sh/install | bash

# NVM For node :(
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
