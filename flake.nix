{
  description = "NixOS configuration for SHIZZA and SHIZZA-MINI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... } @inputs: let
    inherit (self) outputs;

    lib = nixpkgs.lib;
    systems = [ "x86_64-linux" ];
    forEachSystem =  f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {
      inherit system;
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

    
  };
}