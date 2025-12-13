# TODO: Wifi manager?
# exec nm-applet --indicator

# TODO: Bluetooth controls?
#     exec blueman-applet

exec /usr/bin/kdeconnectd
# TODO: What does kdeconnect-indicator do?
#exec kdeconnect-indicator

# What does kanshi actually do?
# # Start Kanshi for hotplugging monitor controls
#     #exec_always kanshi
#     exec_always pkill kanshi; exec kanshi

# Notifications
exec swaync # https://github.com/ErikReider/SwayNotificationCenter

exec opensuse-welcome
