{
  description = "JLK's Dotfiles (home managed)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHomeConfiguration = { system, profile }: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [ ./home-common.nix profile ];
      };
    in {
      homeConfigurations = {
        # Linux configuration
        "MiniPluginBaby" = mkHomeConfiguration {
          system = "x86_64-linux";
          profile = ./home-linux.nix;
        };
        "MiniPluginBaby-headless" = mkHomeConfiguration {
          system = "x86_64-linux";
          profile = ./home-headless.nix;
        };

        # macOS configurations
        "MiniPluginBaby-mac" = mkHomeConfiguration {
          system = "aarch64-darwin";
          profile = ./home-mac.nix;
        };
        "MiniPluginBaby-mac-intel" = mkHomeConfiguration {
          system = "x86_64-darwin";
          profile = ./home-mac-intel.nix;
        };
      };
    };
}
