{ config, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = config.omarchy.shell == "zsh";
    nix-direnv.enable = true;
  };
}
