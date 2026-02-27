{
  description = "JLK's Dotfiles (home managed)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Helper function to create home configuration for a system
      mkHomeConfiguration = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [ ./home.nix ];
      };
    in {
      homeConfigurations = {
        # Linux configuration
        "MiniPluginBaby" = mkHomeConfiguration "x86_64-linux";
        
        # macOS configurations
        "MiniPluginBaby-mac" = mkHomeConfiguration "aarch64-darwin";
        "MiniPluginBaby-mac-intel" = mkHomeConfiguration "x86_64-darwin";
      };
    };
}
