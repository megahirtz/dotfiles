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
            ./hosts/trigo/configuration.nix 
            nixos-hardware.nixosModules.framework
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.megahirtz = {
                imports = [ ./users/megahirtz/home.nix ];
              };
            }
          ];
        };
      };
    };

}
