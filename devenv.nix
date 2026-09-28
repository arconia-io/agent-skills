{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/packages/
  packages = [
    inputs.arconia-cli.packages.${pkgs.stdenv.system}.default
    pkgs.cosign
    pkgs.go-task
    pkgs.jq
    pkgs.oras
  ];

  # See full reference at https://devenv.sh/reference/options/
}
