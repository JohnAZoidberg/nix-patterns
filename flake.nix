{
  description = "NixOS module patterns — examples for kernel, firmware, and package customization";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;

      # Minimal base config for standalone module evaluation
      baseConfig = {
        boot.loader.grub.device = "nodev";
        fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
        nixpkgs.hostPlatform = system;
        system.stateVersion = "24.11";
      };

      # Evaluate module(s) in a minimal NixOS context
      evalModule = modules:
        lib.nixosSystem {
          modules = [ baseConfig ] ++
            (if builtins.isList modules then modules else [ modules ]);
        };

      # All pattern modules combined
      allModules = [
        ./kernel-config.nix
        ./kernel-initrd-modules.nix
        ./kernel-modprobe-config.nix
        ./kernel-patch.nix
        ./kernel-patch-module.nix
        ./kernel-version.nix
        ./linux-firmware.nix
        ./package-overlay-patches.nix
        ./package-overlay-src.nix
        ./patch-acpi-tables.nix
      ];
    in
    {
      # NixOS system with all compatible patterns applied
      nixosConfigurations.all-patterns = evalModule allModules;

      # Bootable ISO image with all patterns
      packages.${system}.iso = let
        isoSystem = lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            { nixpkgs.hostPlatform = system; }
          ] ++ allModules;
        };
      in isoSystem.config.system.build.isoImage;
    };
}
