{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    # required dependencies
    git
    #emacs    # Emacs 27.2
    ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [
      epkgs.emacs-libvterm
    ]))
    ripgrep
    # optional dependencies
    coreutils # basic GNU utilities
    fd
    clang
    texlive.combined.scheme-medium
    direnv
    cmake
    #for vterm install
    gnumake
  ];
}
