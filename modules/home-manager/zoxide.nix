{ config, ... }:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = config.omarchy.shell == "zsh";
  };
}
