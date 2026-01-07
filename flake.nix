{
  description = "NixOS configuration for Void314 Linux";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # https://github.com/Misterio77/nix-colors.git 
    nix-colors.url = "github:misterio77/nix-colors";

    # https://github.com/nix-community/NUR.git
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/nix-community/home-manager.git
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
      self,
      nixpkgs,
      nix-colors,
      home-manager,
      nur,
  }:
  {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    
    nixosModules = {
      default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          imports = [
            (import ./modules/nixos/default.nix inputs)
          ];

          options.omarchy = (import ./config.nix lib).omarchyOptions;
          config = {
            nixpkgs.config.allowUnfree = true;
          };
        };
    };
  };
}