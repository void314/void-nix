inputs:
{
  config,
  pkgs,
  ...
}:
let
  cfg = config.omarchy;
  packages = import ../packages.nix { inherit pkgs; };
in
{
  imports = [
    (import ./system.nix)
    (import ./containers.nix)
  ];
}
