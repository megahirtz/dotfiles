# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, agenix, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nextcloud.nix
    ];
  # Make ready for nix flakes
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';  
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Firewall rules
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 80 443 22 ];
    allowedUDPPorts = [ 51820 ];

    # Think about enabling Wireguard Later
  };
  
  age.secrets.vaultwarden-env.file = ./secrets/vaultwarden-env.age; 
  age.secrets.nextcloud-db = {
    file = ./secrets/nextcloud-db.age;
    owner = "nextcloud";
    group = "nextcloud";
  };
  age.secrets.nextcloud-admin = {
    file = ./secrets/nextcloud-admin.age;
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.vaultwarden = {
    enable = true;
    backupDir = "/mnt/vaultwarden";
    config = {
      WEB_VAULT_FOLDER = "${pkgs.vaultwarden-vault}/share/vaultwarden/vault";
      WEB_VAULT_ENABLED = true;
      LOG_FILE = "/var/log/vaultwarden";
      WEBSOCKET_ENABLED = true;
      WEBSOCKET_ADDRESS = "0.0.0.0";
      WEBSOCKET_PORT = 3012;
      SIGNUPS_VERIFY = true;
      DOMAIN = "https://vaultwarden.megahirtz.run";
      YUBICO_SERVER = "https://api.yubico.com/wsapi/2.0/verify";
      SMTP_HOST = "smtp.mailgun.org";
      SMTP_FROM = "vaultwarden@megahirtz.run";
      SMTP_FROM_NAME = "Vaultwarden";
      SMTP_PORT = 587;
      SMTP_SSL = true;
      SMTP_AUTH = "Login";
      SMTP_TIMEOUT = 15;
      ROCKET_PORT = 8812;
    };
    environmentFile = config.age.secrets.vaultwarden-env.path;
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "k1ngst0n@protonmail.com";
  security.acme.certs = {

    "vaultwarden.megahirtz.run" = {
      group = "nginx";
      keyType = "rsa2048";
    };
  };

  services.jellyfin = {
    enable = true;
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "vaultwarden.megahirtz.run" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8812"; #changed the default rocket port due to some conflict
          proxyWebsockets = true;
        };
        locations."/notifications/hub" = {
          proxyPass = "http://localhost:3012";
          proxyWebsockets = true;
        };
        locations."/notifications/hub/negotiate" = {
          proxyPass = "http://localhost:8812";
          proxyWebsockets = true;
        };
      };
      "nextcloud.megahirtz.run" = {
        forceSSL = true;
        enableACME = true;
      };
      "jellyfin.megahirtz.run" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8096";
          proxyWebsockets = true;
        };
      };
    };
  };

  # Enable ZSH
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.k1ngst0n = {
    isNormalUser = true;
    home = "/home/k1ngst0n";
    description = "Shaun Kingston";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIU/qYWse1/OvAmbH0RAbJfOyR7Zu/eEbXbUzs6IDAzn" ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    inetutils
    mtr
    sysstat
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = { 
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

