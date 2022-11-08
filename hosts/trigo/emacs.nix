{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    # required dependencies
    git
    emacs    # Emacs 27.2
    ripgrep
    # optional dependencies
    coreutils # basic GNU utilities
    fd
    clang
  ];
}