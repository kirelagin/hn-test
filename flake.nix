{
  description = "test";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    haskell-nix.url = "github:input-output-hk/haskell.nix/43cb0fc8957be7ab027f8bd5d48bc22479032c1f";
    nixpkgs.url = "github:serokell/nixpkgs/25cb6c920e31f80cc4c4559c840c5753d4a9012f";
  };

  outputs = { self, nixpkgs, flake-utils, haskell-nix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend haskell-nix.overlay;

        project = pkgs.haskell-nix.stackProject {
          src = pkgs.haskell-nix.haskellLib.cleanGit {
            src = ./.;
            name = "hn-test";
          };
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
