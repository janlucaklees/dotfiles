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
	# macOS: Just apply home-manager
	nix run home-manager/release-24.11 -- switch --flake .#$(HM_CONFIG)
else
	# Linux: Reload Hyprland plugins and apply home-manager
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
