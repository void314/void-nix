{ config, pkgs, ... }:
{
  programs.fish = {
    enable = config.omarchy.shell == "fish";
    
    # Color configuration based on theme palette
    shellInit = ''
      # Set fish colors based on theme
      set -U fish_color_normal ${config.colorScheme.palette.base05}
      set -U fish_color_command ${config.colorScheme.palette.base0D}
      set -U fish_color_quote ${config.colorScheme.palette.base0B}
      set -U fish_color_redirection ${config.colorScheme.palette.base0F}
      set -U fish_color_end ${config.colorScheme.palette.base0C}
      set -U fish_color_error ${config.colorScheme.palette.base08}
      set -U fish_color_param ${config.colorScheme.palette.base05}
      set -U fish_color_comment ${config.colorScheme.palette.base03}
      set -U fish_color_match ${config.colorScheme.palette.base0A}
      set -U fish_color_selection ${config.colorScheme.palette.base02}
      set -U fish_color_search_match --background=${config.colorScheme.palette.base02}
      set -U fish_color_history_current --bold
      set -U fish_color_operator ${config.colorScheme.palette.base0E}
      set -U fish_color_escape ${config.colorScheme.palette.base0C}
      set -U fish_color_cwd ${config.colorScheme.palette.base0D}
      set -U fish_color_cwd_root ${config.colorScheme.palette.base08}
      set -U fish_color_valid_path --underline
      set -U fish_color_autosuggestion ${config.colorScheme.palette.base03}
      set -U fish_color_user ${config.colorScheme.palette.base0B}
      set -U fish_color_host ${config.colorScheme.palette.base0D}
      set -U fish_color_cancel -r
      set -U fish_pager_color_completion ${config.colorScheme.palette.base05}
      set -U fish_pager_color_description ${config.colorScheme.palette.base0A}
      set -U fish_pager_color_prefix ${config.colorScheme.palette.base0D}
      set -U fish_pager_color_progress ${config.colorScheme.palette.base0C}
      
      # Disable greeting
      set -U fish_greeting
      
      # Enable vi mode
      fish_vi_key_bindings
      
      # Auto-run fastfetch on terminal startup
      if status is-interactive
        fastfetch
      end
      
      # Custom key bindings
      bind -M insert \cf accept-autosuggestion
      bind -M insert \ce end-of-line
      bind -M insert \ca beginning-of-line
    '';
    
    # Aliases
    shellAliases = {
      # System
      "ll" = "eza -la --icons --git";
      "la" = "eza -a --icons";
      "ls" = "eza --icons";
      "tree" = "eza --tree --icons";
      "cat" = "bat"; # https://github.com/sharkdp/bat
      "grep" = "rg"; # https://github.com/BurntSushi/ripgrep
      "find" = "fd"; # https://github.com/sharkdp/fd
      "ps" = "procs"; # https://github.com/dalance/procs
      "top" = "btop";
      "htop" = "btop";
      "du" = "dust"; # https://github.com/bootandy/dust
      "df" = "duf"; # https://github.com/muesli/duf
      "ping" = "gping"; # https://github.com/orf/gping
      "cls" = "clear"; # Clear screen
      
      # Git
      "g" = "git";
      "ga" = "git add";
      "gaa" = "git add --all";
      "gb" = "git branch";
      "gc" = "git commit -v";
      "gca" = "git commit -v -a";
      "gcam" = "git commit -a -m";
      "gcm" = "git commit -m";
      "gco" = "git checkout";
      "gd" = "git diff";
      "gl" = "git pull";
      "glog" = "git log --oneline --decorate --graph";
      "gp" = "git push";
      "gst" = "git status";
      "gsta" = "git stash";
      "gstp" = "git stash pop";
      
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      
      # Modern replacements
      "vim" = "nvim";
      "vi" = "nvim";
      
      # System management
      "reload" = "source ~/.config/fish/config.fish";
      "path" = "echo $PATH | tr ':' '\\n'";
      "h" = "history";
      "j" = "z";  # zoxide integration
      
      # Docker
      "d" = "docker";
      "dc" = "docker-compose";
      "dps" = "docker ps";
      "dpa" = "docker ps -a";
      "di" = "docker images";
      "drm" = "docker rm";
      "drmi" = "docker rmi";
      
      # Hyprland
      "hypr-reload" = "hyprctl reload";
      "hypr-restart" = "pkill Hyprland";
    };
    
    # Functions
    functions = {
      # Create directory and cd into it
      mkcd = {
        body = ''
          mkdir -p $argv[1]
          cd $argv[1]
        '';
        description = "Create directory and change to it";
      };
      
      # Extract archives
      extract = {
        body = ''
          if test (count $argv) -ne 1
            echo "Usage: extract <file>"
            return 1
          end
          
          switch $argv[1]
            case "*.tar.bz2"
              tar xjf $argv[1]
            case "*.tar.gz"
              tar xzf $argv[1]
            case "*.bz2"
              bunzip2 $argv[1]
            case "*.rar"
              unrar x $argv[1]
            case "*.gz"
              gunzip $argv[1]
            case "*.tar"
              tar xf $argv[1]
            case "*.tbz2"
              tar xjf $argv[1]
            case "*.tgz"
              tar xzf $argv[1]
            case "*.zip"
              unzip $argv[1]
            case "*.Z"
              uncompress $argv[1]
            case "*.7z"
              7z x $argv[1]
            case "*"
              echo "'$argv[1]' cannot be extracted via extract()"
          end
        '';
        description = "Extract various archive formats";
      };
      
      # Quick file search
      ff = {
        body = "fd -t f -H -I $argv | fzf --preview 'bat --color=always {}'";
        description = "Find files with fzf preview";
      };
      
      # Quick directory search
      fdir = {
        body = "fd -t d -H -I $argv | fzf";
        description = "Find directories with fzf";
      };
      
      # Git commit with message
      gcmsg = {
        body = ''
          if test (count $argv) -eq 0
            echo "Usage: gcmsg <commit message>"
            return 1
          end
          git commit -m "$argv"
        '';
        description = "Git commit with message";
      };
      
      # Theme switcher function
      theme = {
        body = ''
          if test (count $argv) -ne 1
            echo "Available themes:"
            echo "  tokyo-night"
            echo "  kanagawa" 
            echo "  everforest"
            echo "  catppuccin"
            echo "  nord"
            echo "  gruvbox"
            echo "  gruvbox-light"
            echo "  generated_light"
            echo "  generated_dark"
            echo ""
            echo "Usage: theme <theme-name>"
            return 1
          end
          
          echo "Switching to theme: $argv[1]"
          echo "Note: You need to update your omarchy.theme configuration and rebuild"
          echo "Example: omarchy.theme = \"$argv[1]\";"
        '';
        description = "Switch omarchy theme (requires config update and rebuild)";
      };
      
      # System info
      sysinfo = {
        body = ''
          echo "System Information:"
          echo "=================="
          echo "Hostname: "(hostname)
          echo "Uptime: "(uptime | awk '{print $3,$4}' | sed 's/,//')
          echo "Shell: "(echo $SHELL)
          echo "Terminal: "(echo $TERM)
          echo "User: "(whoami)
          echo "Date: "(date)
          echo ""
          echo "Hardware:"
          echo "=========="
          if command -v neofetch >/dev/null
            neofetch --disable theme icons --ascii_distro NixOS
          else
            echo "Install neofetch for detailed system info"
          end
        '';
        description = "Display system information";
      };
    };
    
    # Fish plugins
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];
  };
  
  # Additional packages for fish shell experience
  home.packages = with pkgs; [
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