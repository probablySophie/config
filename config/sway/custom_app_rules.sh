# Get open app ids
# swaymsg -t get_tree | grep "app_id"

# TODO: make thunderbird open full screen
# for_window [app_id="org.mozilla.Thunderbird"] 

#
# Floating Windows
# https://wiki.archlinux.org/title/Sway#Floating_windows

for_window [app_id="org.pulseaudio.pavucontrol"] floating enable;
# Give floating windows title bar (except when floating terminal) 

# for_window [floating] border normal;
# for_window [tiling] border none;

for_window [class="floating"] floating enable;
for_window [window_role="pop-up"] floating enable;
for_window [window_role="About"] floating enable;

for_window [app_id="org.kde.kcalc"] floating enable;
for_window [app_id="org.kde.kdeconnect.*"] floating enable;
for_window [app_id="re.sonny.Junction"] floating enable;
for_window [app_id="org.opensuse.Welcome"] floating enable;
for_window [app_id="org.kde.bluedevilwizard"] floating enable;
