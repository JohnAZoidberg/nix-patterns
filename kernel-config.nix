# Change kernel build config
# Will rebuild the whole kernel! Takes at least half an hour
{ config, pkgs, lib, ... }:
{
  imports = [ ];

  boot.kernelPatches = [
    {
      name = "crashdump-config";
      patch = null;
      # For Thunderbolt/USB4 debugging
      # https://github.com/intel/tbtools
      # extraConfig = ''
      #     USB4_DEBUGFS_WRITE
      # '';
      structuredExtraConfig = {
        USB4_DEBUGFS_WRITE = lib.kernel.yes;
      };
    }
  ];
}
