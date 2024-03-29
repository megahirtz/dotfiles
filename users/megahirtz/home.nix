{ config, pkgs, nix-colors, ... }: {
  imports = [ nix-colors.homeManagerModule ];
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

  home.sessionVariables.NIX_PATH =
    "nixpkgs=${config.xdg.configHome}/nix/inputs/nixpkgs\${NIX_PATH:+:$NIX_PATH}";

  colorScheme = nix-colors.colorSchemes.dracula; 

  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "/home/megahirtz/dotfiles/update.sh";
        auser = "/home/megahirtz/dotfiles/apply-user.sh megahirtz";
        asystem = "/home/megahirt/dotfiles/apply-system.sh trigo";
        v = "nvim -i NONE";
        nvim = "nvim -i NONE";
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
      plugins = [{
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }];
      initExtra = ''
        export PATH=/home/megahirtz/.emacs.d/bin/:$PATH
        eval "$(direnv hook zsh)"
        export EDITOR="nvim"'';
    };
    tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        logging
        { 
          plugin = catppuccin;
          extraConfig = ''
          set -g @catppuccin_flavour 'latte'
          '';
        }
      ];
      extraConfig =''
        set -g mouse on
      '';
    };
    foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          font = "Comic Mono:size=7";
          dpi-aware = "yes";
        };
        colors = {
          foreground= "4c4f69"; # Text
          background= "eff1f5"; # Base
          regular0= "5c5f77";   # Subtext 1
          regular1= "d20f39";   # red
          regular2= "40a02b";   # green
          regular3= "df8e1d";   # yellow
          regular4= "1e66f5";   # blue
          regular5= "ea76cb";   # pink
          regular6= "179299";   # teal
          regular7= "acb0be";   # Surface 2
          bright0= "6c6f85";    # Subtext 0
          bright1= "d20f39";    # red
          bright2= "40a02b";    # green
          bright3= "df8e1d";    # yellow
          bright4= "1e66f5";    # blue
          bright5= "ea76cb";    # pink
          bright6= "179299";    # teal
          bright7= "bcc0cc";    # Surface 1
        };
      };
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
      "image/png" = [ "imv.desktop" ];
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
      "image/png" = [ "imv.desktop" ];
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

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # hyprland stuff
  home.file.".config/hypr" = {
    source = ./hyprland;
    recursive = true;
  };

  # eww stuff
  home.file.".config/eww/eww.scss".source = ./eww/eww.scss;
  home.file.".config/eww/eww.yuck".source = ./eww/eww.yuck;

  # scripts
  home.file.".config/eww/scripts/battery.sh" = {
    source = ./eww/scripts/battery.sh;
    executable = true;
  };

  home.file.".config/eww/scripts/wifi.sh" = {
    source = ./eww/scripts/wifi.sh;
    executable = true;
  };

  home.file.".config/eww/scripts/brightness.sh" = {
    source = ./eww/scripts/brightness.sh;
    executable = true;
  };

  home.file.".config/eww/scripts/workspaces.sh" = {
    source = ./eww/scripts/workspaces.sh;
    executable = true;
  };

  home.file.".config/eww/scripts/workspaces.lua" = {
    source = ./eww/scripts/workspaces.lua;
    executable = true;
  };

  # dunst stuff
  services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "top-left";
        offset = "60x12";
        separator_height = 2;
        padding = 12;
        horizontal_padding = 12;
        text_icon_padding = 12;
        frame_width = 4;
        separator_color = "frame";
        idle_threshold = 120;
        font = "FantasqueSansMono Nerd Font 12";
        line_height = 0;
        format = ''
          <b>%s</b>
          %b'';
        alignment = "center";
        icon_position = "off";
        startup_notification = "false";
        corner_radius = 12;

        frame_color = "#44465c";
        background = "#303241";
        foreground = "#d9e0ee";
        timeout = 2;
      };
    };
  };
  home.file.".config/nvim/settings.lua".source = ./neovim/init.lua;

  home.packages = with pkgs; [
    rnix-lsp
    nixfmt # Nix
    sumneko-lua-language-server
    stylua # Lua
  ];

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      plenary-nvim
      #{
      #  plugin = zk-nvim;
      #  config = "require('zk').setup()";
      #}
      {
        plugin = catppuccin-nvim;
        config = "colorscheme catppuccin-latte";
      }
      {
        plugin = impatient-nvim;
        config = "lua require('impatient')";
      }
      {
        plugin = lualine-nvim;
        config = "lua require('lualine').setup()";
      }
      {
        plugin = telescope-nvim;
        config = "lua require('telescope').setup()";
      }
      {
        plugin = indent-blankline-nvim;
        config = "lua require('indent_blankline').setup()";
      }
      {
        plugin = nvim-lspconfig;
        config = ''
          lua << EOF
          require('lspconfig').rust_analyzer.setup{}
          require('lspconfig').sumneko_lua.setup{}
          require('lspconfig').rnix.setup{}
          require('lspconfig').zk.setup{}
          EOF
        '';
      }
      {
        plugin = nvim-treesitter;
        config = ''
          lua << EOF
          require('nvim-treesitter.configs').setup {
              highlight = {
                  enable = true,
                  additional_vim_regex_highlighting = false,
              },
          }
          EOF
        '';
      }
      {
        plugin = neogit;
        config = "lua require('neogit').setup()";
      }
    ];

    extraConfig = ''
      luafile ~/.config/nvim/settings.lua
    '';
  };
}
