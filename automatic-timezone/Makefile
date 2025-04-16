.PHONY: install
install:
	yay -S --needed --noconfirm \
		tzupdate

.PHONY: config
config:
	stow -vv -d $(shell dirname "$0") -t / config
