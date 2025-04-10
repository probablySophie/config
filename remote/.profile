# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

alias la='ls =A'

alias q="exit"	# because I use neovim and am dumb :(
alias :q="exit"
alias qq="exit"

bind -s 'set completion-ignore-case on' &> /dev/null

# Use vim instead of vi, but only if we have vim installed
if command -v vim &> /dev/null; then
	alias vi="vim"
fi

mesg n 2> /dev/null || tru
