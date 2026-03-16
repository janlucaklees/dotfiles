# Detect operating system
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)
SYSTEMD_DEFAULT_TARGET := $(shell systemctl get-default 2>/dev/null || true)

# Override with `make HEADLESS=1 ...` or `make HEADLESS=0 ...` when needed.
ifeq ($(UNAME_S),Linux)
	HEADLESS ?= $(if $(filter graphical.target,$(SYSTEMD_DEFAULT_TARGET)),0,1)
else
	HEADLESS ?= 0
endif

.PHONY: install install-mac install-mac-intel install-linux install-headless
install:
ifeq ($(UNAME_S),Darwin)
ifeq ($(UNAME_M),arm64)
	$(MAKE) install-mac
else
	$(MAKE) install-mac-intel
endif
else
ifeq ($(HEADLESS),0)
	$(MAKE) install-linux
else
	$(MAKE) install-headless
endif
endif

install-mac:
	@if ! command -v stow >/dev/null 2>&1; then \
		brew install stow; \
	fi
	@if ! command -v nix >/dev/null 2>&1; then \
		curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install | sh; \
	fi
	nix run home-manager/release-24.11 -- switch --flake .#MiniPluginBaby-mac

install-mac-intel:
	@if ! command -v stow >/dev/null 2>&1; then \
		brew install stow; \
	fi
	@if ! command -v nix >/dev/null 2>&1; then \
		curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install | sh; \
	fi
	nix run home-manager/release-24.11 -- switch --flake .#MiniPluginBaby-mac-intel

install-linux:
	@if ! command -v stow >/dev/null 2>&1 || ! command -v nix >/dev/null 2>&1; then \
		yay -S --needed --noconfirm stow nix; \
		systemctl enable --now nix-daemon.socket; \
	fi
	hyprpm reload
	nix run home-manager/release-24.11 -- switch --flake .#MiniPluginBaby

install-headless:
	@if ! command -v stow >/dev/null 2>&1 || ! command -v nix >/dev/null 2>&1; then \
		yay -S --needed --noconfirm stow nix; \
		systemctl enable --now nix-daemon.socket; \
	fi
	nix run home-manager/release-24.11 -- switch --flake .#MiniPluginBaby-headless

.PHONY: update update-mac update-mac-intel update-linux update-headless
update:
ifeq ($(UNAME_S),Darwin)
ifeq ($(UNAME_M),arm64)
	$(MAKE) update-mac
else
	$(MAKE) update-mac-intel
endif
else
ifeq ($(HEADLESS),0)
	$(MAKE) update-linux
else
	$(MAKE) update-headless
endif
endif

update-mac:
	brew update
	brew upgrade
	nix flake update
	nix run home-manager/release-24.11 -- switch --flake .#MiniPluginBaby-mac

update-mac-intel:
	brew update
	brew upgrade
	nix flake update
	nix run home-manager/release-24.11 -- switch --flake .#MiniPluginBaby-mac-intel

update-linux:
	yay -Syu
	hyprpm update
	nix flake update
	nix run home-manager/release-24.11 -- switch --flake .#MiniPluginBaby
	fwupdmgr refresh
	fwupdmgr get-updates
	fwupdmgr update

update-headless:
	yay -Syu
	nix flake update
	nix run home-manager/release-24.11 -- switch --flake .#MiniPluginBaby-headless
	fwupdmgr refresh
	fwupdmgr get-updates
	fwupdmgr update
