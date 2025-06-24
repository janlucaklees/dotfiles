.PHONY: install
install:
	home-manager switch --flake .#MiniPluginBaby

.PHONY: update
update:
	nix flake update
