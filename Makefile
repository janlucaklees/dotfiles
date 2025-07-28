.PHONY: install
install:
	hyprpm reload
	home-manager switch --flake .#MiniPluginBaby

.PHONY: update
update:
	yay -Syu
	hyprpm update
	nix flake update
