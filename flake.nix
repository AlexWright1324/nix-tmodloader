{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
      ];

      systems = import inputs.systems;

      flake = {
        nixosModules = rec {
          tmodloader = import ./module.nix;
          default = tmodloader;
        };
      };

      perSystem =
        { config, pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            inputsFrom = [
              config.pre-commit.devShell
            ];
            packages = with pkgs; [ ];
          };

          pre-commit.settings.hooks = {
            nil.enable = true;
            nixfmt.enable = true;
          };

          formatter = pkgs.nixfmt;
        };
    };
}
