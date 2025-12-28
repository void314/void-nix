{ config, pkgs, ... }:
let
  cfg = config.omarchy;
in
{
  programs.git = {
    enable = true;
    userName = cfg.full_name;
    userEmail = cfg.email_address;
    lfs.enable = true;
    extraConfig = {
      credential.helper = "store";
      # Fix for read-only filesystem issues with Git LFS
      filter.lfs.clean = "git-lfs clean -- %f";
      filter.lfs.smudge = "git-lfs smudge -- %f";
      filter.lfs.process = "git-lfs filter-process";
      filter.lfs.required = true;
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
