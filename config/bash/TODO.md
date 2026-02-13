# Bash Config TODOs

* [ ] The `./commands` and `./tmux` folders *probably* shouldn't be in the base bash config.  Maybe they could be somewhere else & be aliased in `~/.local/bin`?

* [ ] Some of our custom commands (e.g. `tmuxx`) should probably actually be aliases to files instead of functions so that we don't have to parse them on bash init & store them in memory

* [ ] All of our `if -v ${command}; then` COULD be a one-time on login thing?  Maybe we construct a single awful config file blob instead of doing all of the if comparisons every time we open a new tmux window?
