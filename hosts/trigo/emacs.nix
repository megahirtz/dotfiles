{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # required dependencies
    git
    #emacs    # Emacs 27.2
    ((emacsPackagesFor emacs).emacsWithPackages
      (epkgs: [ epkgs.vterm epkgs.autothemer ]))
    ripgrep
    # optional dependencies
    coreutils # basic GNU utilities
    fd
    clang
    # Latex support
    texlive.combined.scheme-medium
    # one of these worked for vterm install
    cmake
    gnumake
    # nix language support
    nixfmt
    # python language support
    black
    python-language-server
    # python-language-server
  ];
}
