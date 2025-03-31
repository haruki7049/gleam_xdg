{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-compat.url = "github:edolstra/flake-compat";
    nix-gleam.url = "github:arnarg/nix-gleam";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          pkgs,
          lib,
          system,
          ...
        }:
        let
          app = pkgs.buildGleamApplication {
            src = lib.cleanSource ./.;
          };
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.nix-gleam.overlays.default
            ];
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.gleam.enable = true;
            programs.actionlint.enable = true;
            programs.mdformat.enable = true;
          };

          packages = {
            inherit app;
            default = app;
          };

          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              # Nix LSP
              pkgs.nil

              # Gleam-lang
              pkgs.gleam
              pkgs.erlang
              #pkgs.rebar3
              #pkgs.elixir
              #pkgs.deno
            ];
          };
        };
    };
}
