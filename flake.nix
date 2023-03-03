{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages

    home-manager = {
      # User Package Management
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master"; # MacOS Package Management
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  }:
  # Function that tells my flake which to use and what do what to do with the dependencies.
  let
    # Variables that can be used in the config files.
    user = "frode";
    location = "$HOME/nixconfig";
  in
    # Use above variables in ...
    {
      darwinConfigurations = {
        Frode-Egeland = darwin.lib.darwinSystem {
          # MacBookAir
          system = "aarch64-darwin"; # System architecture
          specialArgs = {inherit user inputs;};
          modules = [
            # Modules that are used
            ./darwin/work/configuration.nix

            home-manager.darwinModules.home-manager
            {
              # Home-Manager module that is used
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit user;}; # Pass flake variable
              home-manager.users.${user} = import ./darwin/work/home.nix;
            }
          ];
        };

        high-hrothgar = darwin.lib.darwinSystem {
          # MacBookAir
          system = "x86_64-darwin"; # System architecture
          specialArgs = {inherit user inputs;};
          modules = [
            # Modules that are used
            ./darwin/personal/configuration.nix

            home-manager.darwinModules.home-manager
            {
              # Home-Manager module that is used
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit user;}; # Pass flake variable
              home-manager.users.${user} = import ./darwin/personal/home.nix;
            }
          ];
        };
      };
    };
}
