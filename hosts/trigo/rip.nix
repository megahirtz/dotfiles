{config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    makemkv
    handbrake
    vlc
];
}

