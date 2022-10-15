{
  description = "A very complex way to do somethings quite simple";

  inputs = 
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in 
    {
      nixosConfigurations = {
        trigo = lib.nixosSystem {
          inherit system;
          modules = [ 
            {
              environment.etc."nix/inputs/nixpkgs".source = nixpkgs.outPath;
              nix.nixPath = ["nixpkgs=/etc/nix/inputs/nixpkgs"];
              nix.registry.nixpkgs.flake = nixpkgs;
            }
            ./hosts/trigo/configuration.nix 
            nixos-hardware.nixosModules.framework
          ];
        };
      };
      homeConfigurations.megahirtz = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            xdg.configFile."nix/inputs/nixpkgs".source = nixpkgs.outPath;
            nix.registry.nixpkgs.flake = nixpkgs;
          }
          ./users/megahirtz/home.nix
        ];
      };
    };
}
