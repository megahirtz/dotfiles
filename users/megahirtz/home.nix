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
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables.NIX_PATH = "nixpkgs=${config.xdg.configHome}/nix/inputs/nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; 
 
  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "/home/megahirtz/dotfiles/update.sh";
        auser = "/home/megahirtz/dotfiles/apply-user.sh megahirtz";
        asystem = "/home/megahirt/dotfiles/apply-system.sh trigo";
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
        matklad.rust-analyzer
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
    ".config/mako" = {
      source = ./mako;
      recursive = true;
    };
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = "firefox.desktop";
      "image/png" = [
        "imv.desktop"
      ];
      "x-scheme-handler/tg" = [
        "userapp-Telegram Desktop-JT84K1.desktop"
        "userapp-Telegram Desktop-L5Q4O1.desktop"
      ];
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
    };
    defaultApplications = {
      "application/pdf" = "firefox.desktop";
      "image/png" = [
        "imv.desktop"
      ];
      "x-scheme-handler/tg" = "userapp-Telegram Desktop-L5Q4O1.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "x-scheme-handler/nxm" = "modorganizer2-nxm-handler.desktop";
    };
  };

  home.packages = with pkgs ; [
  ];
}
