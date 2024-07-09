{
  description = "CloudScytheLabs core utilities library.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-analyzer-src.follows = "";
    };
  };

  outputs = { self, nixpkgs, fenix, ... }:
  let
    rustToolchainFromTOML = import ./toolchains/rust-toolchain.nix;
  in
  {
    # Handles building project specific toolchains.
    toolchains = {
      # Assumes a `rust-toolchain.toml` is present in the project root
      # and produces the toolchain from it for the given system.
      # Useful for rust projects that declare a `rust-toolchain.toml`.
      mkRustToolchainFromTOML = lib: pkgs: system: toml_path: rustToolchainFromTOML
        { inherit
          lib
          pkgs
          fenix
          system
          toml_path;
        };
    };
  };
}
