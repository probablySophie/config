# Get open app ids
# swaymsg -t get_tree | grep "app_id"

# Or if in KDE: Alt+Space, search 'kwin', Open KWin debug console
# OOORRRR terminal: `kwindowprop` wait until your cursor changes, then click the window you want

# TODO: make thunderbird open full screen - in a new workspace?
# for_window [app_id="org.mozilla.Thunderbird"] 

#
# Floating Windows
# https://wiki.archlinux.org/title/Sway#Floating_windows

for_window [app_id="org.pulseaudio.pavucontrol"] floating enable;
# Give floating windows title bar (except when floating terminal) 

# for_window [floating] border normal;
# for_window [tiling] border none;

for_window [class="floating"] floating enable;

for_window [app_id="org.kde.kcalc"] floating enable, border normal;
for_window [app_id="org.kde.kdeconnect.*"] floating enable, border normal;
for_window [app_id="re.sonny.Junction"] floating enable, border normal;
for_window [app_id="org.opensuse.Welcome"] floating enable, border normal;
for_window [app_id="org.kde.bluedevilwizard"] floating enable, border normal;
for_window [class="vlc"] floating enable, border normal;

# Floaty sorts of window roles
for_window [window_role="pop-up"] floating enable;
for_window [window_role="bubble"] floating enable
for_window [window_role="task_dialog"] floating enable
for_window [window_role="Preferences"] floating enable
for_window [window_type="dialog"] floating enable
for_window [window_type="menu"] floating enable
for_window [window_role="About"] floating enable
