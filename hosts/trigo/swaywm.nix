{ config, pkgs, ... }:
let
  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Catppuccin-Latte'
    '';
  };

  albert_autostart = (pkgs.makeAutostartItem {
    name = "albert";
    package = pkgs.albert;
  });

in {
  environment.systemPackages = with pkgs; [
    alacritty
    sway
    dbus-sway-environment
    configure-gtk
    wayland
    chromium
    glib
    catppuccin-gtk
    dracula-theme
    playerctl
    gnome.adwaita-icon-theme
    gnome.gnome-calendar
    swaylock-effects
    swayidle
    grim
    sway-contrib.grimshot
    slurp
    wl-clipboard
    waybar
    wayfire
    wofi
    albert
    #ulauncher
    albert_autostart
    imagemagick
    bemenu
    rbw
    pinentry
    xdg-utils
    mako
    libnotify
    imv
  ];

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    light = {
      enable = true; # Enables brightness control
    };
    gnupg = {
      agent = {
        enable = true;
        pinentryFlavor = "curses";
        enableSSHSupport = true;
      };
    };
  };

  services = {
    gnome.gnome-keyring = { enable = true; };
    pcscd = {
      enable = true; # Enable rbw to login to Vaultwarden
    };
    dbus.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #gtkUsePortal = true;
  };

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
}
