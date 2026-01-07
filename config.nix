lib: {
  omarchyOptions = {
    full_name = lib.mkOption {
      type = lib.types.str;
      description = "Main user's full name";
      default = "Void User";
    };
    email_address = lib.mkOption {
      type = lib.types.str;
      description = "Main user's email address";
      default = "void@example.com";
    };
    theme = lib.mkOption {
      type = lib.types.either (lib.types.enum [
        "tokyo-night"
        "kanagawa"
        "everforest"
        "catppuccin"
        "nord"
        "gruvbox"
        "gruvbox-light"
        "generated_light"
        "generated_dark"
      ]) lib.types.str;
      default = "nord";
      description = "Theme to use for Omarchy configuration";
    };
    theme_overrides = lib.mkOption {
      type = lib.types.submodule {
        options = {
          wallpaper_path = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Path to the wallpaper image to extract colors from";
          };
        };
      };
      default = { };
      description = "Theme overrides including wallpaper path for generated themes";
    };
    shell = lib.mkOption {
      type = lib.types.enum [ "fish" "zsh" ];
      default = "fish";
      description = "Default shell to use (fish or zsh). Fish is recommended for better experience.";
    };
    primary_font = lib.mkOption {
      type = lib.types.str;
      default = "Liberation Sans 11";
    };
    vscode_settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
    exclude_packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Packages to exclude from the default system packages";
    };
  };
}
