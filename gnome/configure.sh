#!/bin/bash

set -e
set -x

# Enable extensions
gnome-extensions enable arcmenu@arcmenu.com
gnome-extensions enable forge@jmmaranan.com
gnome-extensions enable gsconnect@andyholmes.github.io
gnome-extensions enable Hide_Activities@shay.shayel.org
gnome-extensions enable order-extensions@wa4557.github.com
gnome-extensions enable Vitals@CoreCoding.com

# Install and set configuration
# TODO: Never suspend or turn off screen
# TODO: Setup monitors?
## Appearance
stow -vv -d $(dirname "$0") -t $HOME config
gsettings set org.gnome.desktop.background picture-uri "file:///$HOME/.background.jpg"
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer', 'autoclose-xwayland', 'variable-refresh-rate', 'xwayland-native-scaling']"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface clock-format "24h"
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface show-battery-percentage true
## Forge
gsettings set org.gnome.shell.extensions.forge focus-border-toggle false
gsettings set org.gnome.shell.extensions.forge tiling-mode-enabled true
gsettings set org.gnome.shell.extensions.forge window-gap-size 0
gsettings set org.gnome.shell.extensions.forge auto-split-enabled true
## Vitals
gsettings set org.gnome.shell.extensions.vitals alphabetize false
gsettings set org.gnome.shell.extensions.vitals hide-icons false
gsettings set org.gnome.shell.extensions.vitals hide-zeros false
gsettings set org.gnome.shell.extensions.vitals hot-sensors "['_processor_usage_', '_memory_usage_', '__network-rx_max__', '_temperature_cros_ec_cpu@4c_', '__fan_avg__']"
gsettings set org.gnome.shell.extensions.vitals position-in-panel 3
## Night Light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 2700
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
gsettings set org.gnome.settings-daemon.plugins.color night-light-last-coordinates "(51.9, 8.8)"
## Input configuration
gsettings set org.gnome.desktop.input-sources xkb-options "['compose:rctrl', 'lv3:ralt_switch', 'ctrl:swapcaps', 'altwin:swap_alt_win']"
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+altgr-intl'), ('xkb', 'de')]"
## Workspace configuration
gsettings set org.gnome.mutter workspaces-only-on-primary true
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10
gsettings set org.gnome.shell.keybindings open-new-window-application-1 "[]"
gsettings set org.gnome.shell.keybindings open-new-window-application-2 "[]"
gsettings set org.gnome.shell.keybindings open-new-window-application-3 "[]"
gsettings set org.gnome.shell.keybindings open-new-window-application-4 "[]"
gsettings set org.gnome.shell.keybindings open-new-window-application-5 "[]"
gsettings set org.gnome.shell.keybindings open-new-window-application-6 "[]"
gsettings set org.gnome.shell.keybindings open-new-window-application-7 "[]"
gsettings set org.gnome.shell.keybindings open-new-window-application-8 "[]"
gsettings set org.gnome.shell.keybindings open-new-window-application-9 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Super>1']"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Super>2']"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Super>3']"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Super>4']"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Super>5']"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Super>6']"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Super>7']"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Super>8']"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Super>9']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>9']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "[]"
## Arc-Menu
gsettings set org.gnome.shell.extensions.arcmenu menu-button-appearance 'None'
gsettings set org.gnome.shell.extensions.arcmenu hide-overview-on-startup true
gsettings set org.gnome.shell.extensions.arcmenu menu-layout 'Runner'
gsettings set org.gnome.shell.extensions.arcmenu multi-monitor false
gsettings set org.gnome.shell.extensions.arcmenu position-in-panel 'Center'
gsettings set org.gnome.shell.extensions.arcmenu runner-hotkey-open-primary-monitor true
gsettings set org.gnome.shell.extensions.arcmenu runner-position 'Centered'
gsettings set org.gnome.shell.extensions.arcmenu show-activities-button false
### Custom Shortcut
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Super>shift']"
gsettings set org.gnome.shell.extensions.arcmenu arcmenu-hotkey "['<Super>space']"
## Custom keybindings
### Shortcut to launch terminal
gsettings set org.gnome.shell.extensions.forge.keybindings window-swap-last-active "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>Return'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'foot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Launch Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
