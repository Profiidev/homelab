{
  description = "Homelab NixOS Install";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }@inputs: let
    nodes = [
      "homelab-0"
      "homelab-1"
      "homelab-2"
    ];
  in {
    nixosConfigurations = builtins.listToAttrs(map (name: {
      name = name;
      value = nixpkgs.lib.nixosSystem {
        specialArgs = {
          meta = { hostname = name; };
        };
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hardware-config.nix
          ./disko-config.nix
          ./config.nix
        ];
      };
    }) nodes);
  };
}
