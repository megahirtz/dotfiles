{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        hydroxide
        thunderbird
    ]
}