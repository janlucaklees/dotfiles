# Detect operating system
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Determine home-manager configuration name
ifeq ($(UNAME_S),Darwin)
	ifeq ($(UNAME_M),arm64)
		HM_CONFIG := MiniPluginBaby-mac
	else
		HM_CONFIG := MiniPluginBaby-mac-intel
	endif
else
	HM_CONFIG := MiniPluginBaby
endif

.PHONY: install
install:
ifeq ($(UNAME_S),Darwin)
	# macOS: Install stow and apply home-manager
	@if ! command -v stow >/dev/null 2>&1; then \
		brew install stow; \
	fi
	@if ! command -v nix >/dev/null 2>&1; then \
		curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install | sh; \
	fi
	nix run home-manager/release-24.11 -- switch --flake .#$(HM_CONFIG)
else
	# Linux: Install stow, reload Hyprland plugins and apply home-manager
	@if ! command -v stow >/dev/null 2>&1 || ! command -v nix >/dev/null 2>&1; then \
		yay -S --needed --noconfirm stow nix; \
	fi
	hyprpm reload
	nix run home-manager/release-24.11 -- switch --flake .#$(HM_CONFIG)
endif

.PHONY: update
update:
ifeq ($(UNAME_S),Darwin)
	# macOS: Update Homebrew and Nix flake
	brew update
	brew upgrade
	nix flake update
	home-manager switch --flake .#$(HM_CONFIG)
else
	# Linux: Update yay, Hyprland plugins, Nix flake, and firmware
	yay -Syu
	hyprpm update
	nix flake update
	home-manager switch --flake .#$(HM_CONFIG)
	fwupdmgr refresh
	fwupdmgr get-updates
	fwupdmgr update
endif
