
if command -v tmux --help &> /dev/null
then

	_tmuxx()
	{
		# If there are no arguments
		if [ $# -eq 0 ]; then
			_tmuxx_default
			return
		fi

		# HUGO!
		if [ $1 -eq "hugo" ]; then
			_tmuxx_hugo
			return
		fi
	}

else
	printf "I'm very sorry, but you don't appear to have tmux installed\n\n"
fi

descriptive_alias "tmuxx" "_tmuxx" "Set up our preferred tmux layout!"

_tmuxx_default()
{
	tmux new -d # make a new tmux session

	tmux splitw -dh # split <->
	tmux selectp -t 1
	tmux splitw -v

	tmux a # Attach to the session
}

_tmuxx_hugo()
{
	tmux new -d # New tmux session :)
	
	tmux send-keys "docker run --rm --name hugo-server --mount src="$(pwd)",target=/hugo,type=bind -p 1313:1313 -it alpine/hugo" Enter
	
	tmux splitw -dh # split <->
	tmux splitw -v

	tmux a # attach
}
