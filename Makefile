.PHONY: install
install:
	hyprpm reload
	home-manager switch --flake .#MiniPluginBaby

.PHONY: update
update:
	hyprpm update
	nix flake update
