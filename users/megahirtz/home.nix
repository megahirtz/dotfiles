{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "megahirtz";
  home.homeDirectory = "/home/megahirtz";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  nixpkgs.config.allowUnfree = true;

  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch -I nixos-config='/home/megahirtz/.dotfiles/hosts/trigo/configuration.nix";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "gnzh";
      };
      plugins = [
        {
          # will source zsh-autosuggestions.plugin.zsh
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.4.0";
            sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
          };
        }
      ];
    };
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # Some example extensions...
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
        tabnine.tabnine-vscode
      ];
    };
  };

  home.file = {
    ".config/waybar" = {
      source = ./waybar;
      recursive = true;
    };
    ".config/sway" = {
      source = ./sway;
      recursive = true;
    };
    ".config/swaylock" = {
      source = ./swaylock;
      recursive = true;
    };
  };

  home.packages = with pkgs ; [
  ];
}
