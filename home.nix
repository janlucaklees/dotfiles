{ config, pkgs, lib, ... }:

{
  imports = [
    ./zsh/zsh.nix
    ./kdeconnect/kdeconnect.nix
  ];

  home.username = "jlk";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/jlk" else "/home/jlk";
  home.stateVersion = "24.11";
  home.sessionPath = [ "$HOME/.nix-profile/bin" ];

  programs.home-manager.enable = true;
}
