# Patch a single kernel module
# This does NOT rebuild the whole kernel, only that single module. It's very fast
{ config, pkgs, lib, ... }:
let
  pac195x-kernel-module = pkgs.callPackage ./pac195x-driver.nix {
    # Make sure the module targets the same kernel as your system is using.
    kernel = config.boot.kernelPackages.kernel;
  };
in
{
  imports = [ ];

  boot.extraModulePackages = [
    (pac195x-kernel-module.overrideAttrs (_: {
      # iio: adc: adding support for PAC194X
      patches = [
        (fetchpatch {
          name = "pac1954.patch";
          url = "https://github.com/linux4microchip/linux/commit/e84c75cd98af11b8ac0b6bd4174a2d612e735eec.patch";
          sha256 = "sha256-ZhA4As/GD/FY0p//AAlpDL28bUoH+SMUidGd6RoODe0=";
        })
      ];
    }))
  ];
}
