{ config, pkgs, ... }:

{
  imports = [
    ./kdeconnect/kdeconnect.nix
    ./zsh/zsh.nix
  ];

  home.username = "jlk";
  home.homeDirectory = "/home/jlk";
  home.stateVersion = "24.11";
  home.sessionPath = [ "$HOME/.nix-profile/bin" ];

  programs.home-manager.enable = true;
}
