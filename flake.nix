{
  description = "A very complex way to do somethings quite simple";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:megahirtz/nixpkgs/tmux/catppuccin";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors = { url = "github:misterio77/nix-colors"; };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # build with your own instance of nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, hyprland, home-manager, agenix
    , nix-colors, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        trigo = lib.nixosSystem {
          inherit system;
          modules = [
            {
              environment.etc."nix/inputs/nixpkgs".source = nixpkgs.outPath;
              nix.nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
              nix.registry.nixpkgs.flake = nixpkgs;
            }
            ./hosts/trigo/configuration.nix
            nixos-hardware.nixosModules.framework
            agenix.nixosModule
            hyprland.nixosModules.default
            { programs.hyprland.enable = true; }
          ];
        };
        nixos = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/nixos/configuration.nix agenix.nixosModule ];
        };
        nixos-us-iad = lib.nixosSystem {
            inherit system;
            modules = [ ./hosts/nixos-us-iad/configuration.nix agenix.nixosModule ];
        };
      };
      homeConfigurations = {
        megahirtz = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit nix-colors; };
          modules = [
            {
              xdg.configFile."nix/inputs/nixpkgs".source = nixpkgs.outPath;
              nix.registry.nixpkgs.flake = nixpkgs;
            }
            ./users/megahirtz/home.nix
          ];
        };
        k1ngst0n = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/k1ngst0n/home.nix ];
        };
      };
    };
}
