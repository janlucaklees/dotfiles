{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    plasma5Packages.kdeconnect-kde
    plasma5Packages.kde-cli-tools
  ];

  # Autostart via systemd (user-level) for kdeconnectd
  systemd.user.services.kdeconnect = {
    Unit = {
      Description = "KDE Connect Daemon";
      After = [ "graphical-session.target" "network-online.target" ];
      Wants = [ "network-online.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.plasma5Packages.kdeconnect-kde}/libexec/kdeconnectd";
      Restart = "on-abort";
    };
  };
}
