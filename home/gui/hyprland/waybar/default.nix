{ pkgs, ... }:

{
  home.packages = with pkgs ; [
    waybar
  ];

  xdg.configFile."waybar/" = {
    source = ./config;
    recursive = true;
  };

  # Home-manager waybar config
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
}
