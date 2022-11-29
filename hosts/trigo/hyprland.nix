{ config, hyprland, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wofi
    swaybg
    wlsunset
    wl-clipboard
    hyprland
    eww-wayland
    pamixer
    brightnessctl
    dunst
  ];

}
