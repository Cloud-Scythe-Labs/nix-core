{ lib, pkgs, fenix, system, toml_path }:
let
  fenix-pkgs = (fenix.packages.${system}.fromToolchainFile {
    file = toml_path;
    sha256 = "sha256-opUgs6ckUQCyDxcB9Wy51pqhd0MPGHUVbwRKKPGiwZU=";
  });
  darwin-pkgs = (with pkgs; lib.optionals stdenv.isDarwin [
    # Additional darwin specific inputs
    libiconv
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ]);
in
{
  fenix-pkgs = fenix-pkgs;
  darwin-pkgs = darwin-pkgs;
  complete = [ fenix-pkgs darwin-pkgs ];
}
