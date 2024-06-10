{
  description = "My Home Manager flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { nixpkgs, flake-utils, home-manager, ... }@inputs:
  let
    system = flake-utils.lib.system.x86_64-linux;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations = {
      "louis" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];

        extraSpecialArgs = { inherit (inputs) nix-colors; };
      };
    };
    # devShells.${system}.default = (import ./shell.nix { inherit pkgs; });
  };
}
