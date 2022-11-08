{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        hydroxide
        thunderbird
        protonmail-bridge
    ];
}