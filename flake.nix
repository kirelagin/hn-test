{
  description = "test";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    haskell-nix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskell-nix/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, haskell-nix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          overlays = [ haskell-nix.overlay ];
          inherit system;
        };

        project = pkgs.haskell-nix.stackProject {
          src = ./.;
        };
        package = project.hn-test;
      in rec {
        packages = {
          hn-test = package.components.library;
        };
        defaultPackage = packages.hn-test;
      }
    );
}
