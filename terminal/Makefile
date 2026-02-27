# Detect operating system
UNAME_S := $(shell uname -s)

.PHONY: install
install:
ifeq ($(UNAME_S),Darwin)
	brew install --cask ghostty
else
	yay -S --needed --noconfirm \
		foot
endif

.PHONY: config
config:
	stow -vv -d ${PWD} -t ${HOME} config
