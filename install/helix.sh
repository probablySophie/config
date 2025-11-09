
git clone https://github.com/helix-editor/helix ~/Downloads/helix
PREV_DIR="$(pwd)"
cd ~/Downloads/helix

cargo install \
   --profile opt \
   --config 'build.rustflags="-C target-cpu=native"' \
   --path helix-term \
   --locked

mkdir p ~/.config/helix
cp -r runtime ~/.config/helix/

hx --grammars fetch
hx --grammars build

cd "$PREV_DIR"
rm -rdf ~/Downloads/helix
