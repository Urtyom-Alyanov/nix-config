{
  description = "NixOS configuration for SHIZZA and SHIZZA-MINI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dinamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };
    loginom = {
      url = "github.com:Urtyom-Alyanov/loginom-community-package";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/hyprland";
  };

  outputs = { self, home-manager, nur, nixpkgs, plasma-manager, ... } @inputs: let
    inherit (self) outputs;
    overlays = [
      final: prev: {
        loginom-community = inputs.loginom.packages.${final.system}.loginom-community;
        hyprland = inputs.hyprland.packages.${final.system}.hyprland;
        xdg-desktop-portal-hyprland = inputs.hyprland.packages.${final.system}.xdg-desktop-portal-hyprland;
        hyprlandPlugins = inputs.hyprland-plugins.packages.${final.system};
        hyprlandPlugins.hypr-dynamic-cursors = inputs.hypr-dynamic-cursors.packages.${final.system}.hypr-dynamic-cursors;
      }
      (final: prev: import ./packages { inherit (final) lib; })
    ] ++ (import ./overlays);

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
                nur.modules.nixos.default
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
          modules = [
            nur.modules.homeManager.default
            plasma-manager.homeModules.plasma-manager
            ./home
          ];
        };
        pkgs = pkgsFor.x86_64-linux;
      };
    };
}