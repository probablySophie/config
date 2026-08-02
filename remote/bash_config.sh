
#
# INFO: Basic config
# 

bind -s 'set completion-ignore-case on' &> /dev/null


#
# INFO Possibly existing extras
#

if [ -f "$HOME/.cargo/env" ]; then . "$HOME/.cargo/env"; fi


#
# INFO: Aliases
# 

if command -v hx &> /dev/null; then EDITOR="hx";
elif command -v nvim &> /dev/null; then EDITOR="nvim";
elif command -v vim &> /dev/null; then EDITOR="vim";
elif command -v nano &> /dev/null; then EDITOR="nano";
elif command -v vi &> /dev/null; then EDITOR="vi";
fi
if [[ "$EDITOR" != "" ]]; then alias e="$EDITOR"; fi

alias q="exit";

