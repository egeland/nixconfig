#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix *
#       ├─ configuration.nix
#       └─ home.nix
#
{
  lib,
  inputs,
  nixpkgs,
  home-manager,
  darwin,
  user,
  ...
}: let
  system = "x86_64-darwin"; # System architecture
in {
  high-hrothgar = darwin.lib.darwinSystem {
    # MacBookAir
    inherit system;
    specialArgs = {inherit user inputs lib;};
    modules = [
      # Modules that are used
      ./configuration.nix

      home-manager.darwinModules.home-manager
      {
        # Home-Manager module that is used
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit user;}; # Pass flake variable
        home-manager.users.${user} = import ./home.nix;
      }
    ];
  };
}
