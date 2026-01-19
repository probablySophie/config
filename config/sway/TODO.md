# Sway TODO

Alternatively... do none of this and stick with KDE.
* [Arch Wiki](wiki.archlinux.org/title/Sway)  
* [Community Wiki](https://github.com/swaywm/sway/wiki)  
* [Are we Wayland yet?](https://arewewaylandyet.com/)

## Setup/Install

* [ ] Get backgrounds working/settings
	* [ ] Alternate images from a set folder like `~/Pictures/Backgrounds` or `~/Pictures/Desktops`?
* [Running programs natively under wayland](https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland)

* [ ] [`swayidle`](https://github.com/swaywm/swayidle) for idle management (going to sleep after a given time period) ([Arch Wiki](wiki.archlinux.org/title/Sway#Idle))
* [ ] [`swaylock`](https://github.com/swaywm/swaylock) for screen locking?
* [ ] [`swaybg`](https://github.com/swaywm/swaybg) for wallpaper setting/managing?
* [ ] Figure out a global dark mode so apps actually show their dark modes (kde, gnome)
* [ ] More fancieness with `swaync`? (`../swaync/swaync.md`)
* [ ] Get terminal/tmux clipboards working

## Find

* [ ] A login manager
* [ ] A screenshot GUI like KDE's Spectacle (can we use Spectacle??) ([flameshot](https://flameshot.org/)??)
* [ ] A wifi/network/vpn manager (`nm-applet`?)
* [ ] A bluetooth manager
* [ ] Something that plays well with touchscreens
* [ ] A half decent way to play music from playlists (and music in general)
* [ ] A clipboard manager ([`clipman`](https://github.com/chmouel/clipman)?)
* [ ] A file-browser (Dolphin?)
* [ ] Screen recording/sharing (`pipewire` + `wireplumber`?)
* [ ] Widgets?  ([ElKowars](https://github.com/elkowar/eww)) - would this act as the bar instead of `swaybar` or `waybar`?
* [ ] We need a system tray, either inside `waybar`, `swaybar`, or `eww`

* [ ] All of the things required for a standalone/usable DE
	* [Useful addons for sway](https://github.com/swaywm/sway/wiki/Useful-add-ons-for-sway)
	* [Are we Wayland yet?](https://arewewaylandyet.com/)

## Fix

* [ ] Fix the weird issue that was happening with the calculator ([fix?](https://github.com/swaywm/sway/wiki#my-favorite-application-isnt-displayed-right-how-can-i-fix-this))
* [ ] Can we add `caption="Picture-in-Picture"` or `captionNormal="Picture-in-Picture"` to floating in `./config.d/custom_app_rules.sh`?


## Bar?

Left
```
 now playing | Workspaces
```

Center
```
Currently open app's icons |  Scratchpad
```
The scratchpad thing should show what's in the scratchpad when hovered
Something like this? (also window titles apparently need to have `&` replaced with something else)
```json
 "custom/scratchpad-indicator": {
	"interval": 3,
	"return-type": "json",
	"exec": "swaymsg -t get_tree | jq --unbuffered --compact-output '( select(.name == \"root\") | .nodes[] | select(.name == \"__i3\") | .nodes[] | select(.name == \"__i3_scratch\") | .focus) as $scratch_ids | [..  | (.nodes? + .floating_nodes?) // empty | .[] | select(.id |IN($scratch_ids[]))] as $scratch_nodes | { text: \"\\($scratch_nodes | length)\", tooltip: $scratch_nodes | map(\"\\(.app_id // .window_properties.class) (\\(.id)): \\(.name)\") | join(\"\\n\") }'",
	"format": "{}  ﳶ ",
	"on-click": "exec swaymsg 'scratchpad show'",
	"on-click-right": "exec swaymsg 'move scratchpad'"
},
```


Right
```
Time-Date       ⏻
```
Can the brightness & volume change to their percentages when hovered?

### Bar menus/widgets?

Brightness scroller bar
Volume scroller bar
Display management & screen sharing
Notification list

Wifi management


## Widgets?

System Info?  (only update when visible)
* Disk Space X/Y
* Memory X/Y
* CPU 
