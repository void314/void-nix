```nix
{
  description = "Void314 Omarchy for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    void-nix = {
      url = "github:void314/void-nix";
      # inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.nixpkgs.follows = "nixpkgs";

      inputs.home-manager.follows = "home-manager";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, void-nix, home-manager, ... }: {
    nixosConfigurations.void-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix

        # Подключаем void-nix и home-manager
        void-nix.nixosModules.default
        home-manager.nixosModules.home-manager

        # Описываем конфигурацию
        {
          omarchy = {
            full_name = "void314";
            email_address = "artiemdrozdov@yandex.kz";
            theme = "tokyo-night";
            shell = "fish";
          };

          home-manager.users.void314 = {
            imports = [ void-nix.homeManagerModules.default ];
            home.stateVersion = "25.11";

            nixpkgs = {
    	       config.allowUnfree = true;
  	        };
          };
        }
      ];
    };
  };
}
```
