{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.omarchy;
  packages = import ../packages.nix {
    inherit pkgs lib;
    exclude_packages = cfg.exclude_packages;
  };
in
{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Shell configuration
  programs.fish.enable = cfg.shell == "fish";
  programs.zsh.enable = cfg.shell == "zsh";
  
  # Set default shell for users
  users.defaultUserShell = if cfg.shell == "fish" then pkgs.fish else pkgs.zsh;

  # Install packages
  environment.systemPackages = packages.systemPackages;
  programs.direnv.enable = true;

  # Networking
  services.resolved.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = false;
  networking = {
    networkmanager.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.caskaydia-mono
  ];
}
