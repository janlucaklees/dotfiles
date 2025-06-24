.PHONY: install
install:
	# Core
	yay -S --needed --noconfirm \
		hyprland \
		xdg-desktop-portal-hyprland \
		hyprpolkitagent \
		qt5-wayland \
		qt6-wayland \
		hyprland-qt-support \
		hyprutils \
		hypridle \
		hyprlock \
		brightnessctl \ # Control screen brightness
		mako \ # Notifications
		ashell \ # Status bar
		hyprpaper \ # Wallpapers
		power-profiles-daemon \
		upower \
		tofi \ # App launcher
		smile \ # emoji picker
		hyprsunset \ # Reduce blue light
		clight \ # sutomatic screen brightness and color temp
		jq \
		bc \
		hyprsysteminfo \ # System information
		hyprshot \ # Screenshots
		jq \
		grim \
		slurp \
		wl-clipboard \
		libnotify \
		hyprpicker \
		overskride # Bluetooth UI
		fcitx5-gtk \
		fcitx5-nord \
		nwg-look \
		nordic-theme \
		papirus-icon-theme \
		superfile

		# Cursor
		yay -S --needed --noconfirm \
				cmake \
				meson \
				cpio \
				pkg-config
		hyprpm update
		hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
		hyprpm enable dynamic-cursors


.PHONY: config
config:
	stow -vv -d ${PWD} -t ${HOME} config
