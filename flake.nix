{
  description = "NixOS configuration for SHIZZA and SHIZZA-MINI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, home-manager, nixpkgs, ... } @inputs: let
    inherit (self) outputs;
    overlays = [ (import ./overlays) ];

    lib = nixpkgs.lib;
    systems = [ "x86_64-linux" ];
    forEachSystem =  f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    });
    in rec {
      nixosConfigurations = 
        lib.mapAttrs (name: value:
          lib.nixosSystem {
            inherit lib;

            system = "x86_64-linux";
            modules = [
                ./system
                ./desktop
                ./machines/${name}
                {
                  environment.etc.current-config.text = "${toString self}";
                  networking.hostName = name;
                }
              ];
            specialArgs = { inherit inputs outputs; };
          }
        ) (
          builtins.removeAttrs (
            builtins.readDir ./machines
          ) [ "common" ]
        );

      homeConfigurations.artemos = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit inputs outputs;
          lib = lib.extend (_: _: inputs.home-manager.lib);
          modules = [ ./home ];
        };
        pkgs = pkgsFor.x86_64-linux;
      };
    };
}