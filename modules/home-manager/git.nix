{ config, pkgs, ... }:
let
  cfg = config.omarchy;
in
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = cfg.full_name;
        email = cfg.email_address;
      };
      credential.helper = "store";
      # Fix for read-only filesystem issues with Git LFS
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  # Ensure git-lfs is available in the environment
  home.packages = with pkgs; [
    git-lfs
  ];
}
