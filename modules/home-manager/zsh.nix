{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = config.omarchy.shell == "zsh";
    autosuggestion.enable = true;
    
    # Auto-run fastfetch on terminal startup for zsh
    initContent = ''
      if [[ $- == *i* ]]; then
        fastfetch
      fi
    '';
    
    zplug = {
      enable = true;
      plugins = [
        {
          name = "plugins/git";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "fdellwing/zsh-bat";
          tags = [ "as:command" ];
        }
      ];
    };
  };
  
  # Additional packages for zsh shell experience (same as fish)
  home.packages = with pkgs; lib.mkIf (config.omarchy.shell == "zsh") [
    bat          # Better cat
    eza          # Better ls
    fd           # Better find
    ripgrep      # Better grep
    fzf          # Fuzzy finder
    zoxide       # Better cd
    dust         # Better du
    gping        # Ping with graph
    procs        # Better ps
    duf          # Better df
    fastfetch    # System info display
  ];
}
