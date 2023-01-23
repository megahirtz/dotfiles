# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c sway; swaymsg exit"
    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'
  '';

in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./swaywm.nix
    ./mail.nix
    ./emacs.nix
    ./hyprland.nix
  ];
  nix = {
    package = pkgs.nixVersions.stable; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
  };

  #system.autoUpgrade = {
  #  enable = true;
  #  channel = "https://nixos.org/channels/nixos-unstable";
  #};
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.trusted-users = [ "root" "megahirtz" ];

  networking.hostName = "trigo"; # Define your hostname.
  time.timeZone = "America/Los_Angeles";

  networking.useDHCP = false;

  programs.zsh.enable = true;

  programs.nm-applet.enable = true;

  #greetd nonsense
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
      };
    };
  };

  environment.etc = {
    "greetd/environments".text = ''
      sway
      zsh
      Hyprland
    '';
    #"greetd/gtkgreet.css".text = ''
    #  window {
    #     background-image: url("file:///usr/share/backgrounds/default.png");
    #     background-size: cover;
    #     background-position: center;
    #  }
    #
    #  box#body {
    #     background-color: rgba(50, 50, 50, 0.5);
    #     border-radius: 10px;
    #     padding: 50px;
    #  }
    #''; 
  };

  users.users.megahirtz = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "adbuser"
      "libvirtd"
      "kvm"
      "qemu-libvirtd"
      "dialout"
      "video"
    ]; # Enable ‘sudo’ for the user.
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" "Iosevka" "FantasqueSansMono" "JetBrainsMono" ];
    })
    font-awesome_5
    comic-mono
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
      swtpm = { enable = true; };
    };
  };
  environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox-wayland
    git
    discord
    jq
    minecraft
    pavucontrol
    tdesktop
    htop
    prismlauncher
    cachix
    lutris
    virt-manager
    win-virtio
    zoom-us
    onlyoffice-bin
    protontricks
    gnome.zenity
    p7zip
    pulseaudio
    spotifyd
    jellycli
    deluge
    calibre
    nextcloud-client
    gamescope
  ];

  # Firmware updates
  services.fwupd.enable = true;
  services.udisks2.enable = true;

  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;

  programs.steam.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  programs.adb.enable = true;

  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

