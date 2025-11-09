# Pre-reqs
zypper install cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel gcc-c++ tic

git clone https://github.com/alacritty/alacritty.git ~/Downloads/alacritty
PREV_DIR="$(pwd)"
cd ~/Downloads/alacritty

rustup override set stable
rustup update stable

cargo build --release

mkdir -p ~/.local/completions
cp "$(pwd)/extra/completions/alacritty.bash" ~/.local/completions/alacritty.sh
echo "source ~/.local/completions/alacritty.sh" >> ~/.bashrc

sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

cd "$PREV_DIR"
rm -rdf ~/Downloads/alacritty
