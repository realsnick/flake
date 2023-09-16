{
  description = "My Personal NixOS ricing";

  inputs = {
    nixos-hardware.url = "github:realsnick/nixos-hardware/master";
    #nixos-hardware.url = "../../../home/snick/Code/nix/nixos-hardware";

    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "/home/snick/Code/snick/nix/nixpkgs";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05"; #-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # managing secrets
    sops-nix.url = "github:Mic92/sops-nix";

    secrets = {
      url = "/home/snick/.secrets/";
      flake = false;
    };

    # secrets.url = "github:realsnick/secrets";
    # managing partitions
    disko = {
      url = github:nix-community/disko;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # managing /home - user configurations - dotfiles
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # might need it for user login
    # hyprland = {
    # url = "github:hyprwm/Hyprland";
    # inputs.nixpkgs.follows = "nixpkgs";
    # };

    # themes
    stylix.url = "github:danth/stylix";
    #stylix.url = "github:realsnick/stylix";
    # stylix.url = "../../../home/snick/Code/github/snick/stylix";
  };

  outputs = inputs @ {
    self,
    nixos-hardware,
    nixpkgs,
    # nixpkgs-stable,
    disko,
    flake-utils,
    sops-nix,
    secrets,
    home-manager,
    stylix,
    ...
  }: let
    username = "snick";
    lib = nixpkgs.lib;
    # pkgs-stable = import nixpkgs-stable {
    # system = "x86_64-linux";
    # config.allowUnfree = true;
    # };
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true; # Allow proprietary software
    };
  in {
    nixosConfigurations = {
      handlink = lib.nixosSystem {
        specialArgs = {inherit pkgs secrets disko self inputs username;}; #hyprland
        modules = [
          # hardware
          nixos-hardware.nixosModules.lenovo-legion-16irx8h #2023
          # partitioning
          ({modulesPath, ...}: {
            imports = [
              (modulesPath + "/installer/scan/not-detected.nix")
              (modulesPath + "/profiles/qemu-guest.nix")
              disko.nixosModules.disko
            ];
            disko.devices = import ./Systems/mirage/configuration-disks.nix {
              lib = nixpkgs.lib;
            };
          })

          # secrets
          sops-nix.nixosModules.sops
          # system
          ./hosts/handlink.nix
          modules/oct-motd
          # Home
          home-manager.nixosModules.home-manager
          {
            #home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.${username} = {
              imports = [
                # hyprland.homeManagerModules.default
                # {wayland.windowManager.hyprland.enable = true;}
                ./home/${username}.nix
              ];
            };
          }

          # Theme
          stylix.nixosModules.stylix
          Themes/stylix.nix
        ];
      };

      #bumblebee = {
      #  system = "x86_64-linux";
      #  # specialArgs = { inherit nixpkgs self inputs user; };
      #  modules = [
      #    ./bumblebee/configuration.nix
      #  ];
      #};
    };
  };
}
