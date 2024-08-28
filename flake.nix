{
  description = "CloudScytheLabs core utilities library.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-analyzer-src.follows = "";
    };
  };

  outputs = { nixpkgs, flake-utils, fenix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;
        rustToolchainFromTOML = import ./toolchains/rust-toolchain.nix;
      in
      {
        # Handles building project specific toolchains.
        toolchains = {
          # Given the path to a `rust-toolchain.toml`, produces the derivation
          # for that toolchain for linux and darwin systems.
          # Useful for rust projects that declare a `rust-toolchain.toml`.
          mkRustToolchainFromTOML = toml_path: hash:
            rustToolchainFromTOML {
              inherit
                lib
                pkgs
                fenix
                system
                toml_path
                hash;
            };
        };
      }
    );
}
