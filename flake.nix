{
  description = "Bren's NixOS system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      host = "stilas";
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [ ./system.nix ];
      };
    };
}

