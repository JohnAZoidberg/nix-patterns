# Enable ChromeOS EC I2C Tunnel passthrough
# Exposes the EC's internal I2C buses to the host via cros-ec-i2c-tunnel.
#
# Requires the CREC device (FRMWC004) to already exist in ACPI — either from
# firmware or from the add-ssdt pattern. The SSDT here adds GOOG0012 tunnel
# devices as children of CREC.
#
# Prerequisites:
#   - cros_ec_lpcs must be loaded and bound to FRMWC004
#   - The add-ssdt SSDT (which defines CREC) must also be loaded
#
# After boot, new I2C adapters named "cros-ec-i2c-tunnel" will appear.
# Verify with: i2cdetect -l
{ config, pkgs, lib, ... }:
{
  imports = [ ];

  # Load the tunnel SSDT into initrd so ACPI picks it up at boot
  boot.initrd.prepend = [
    "${(pkgs.callPackage ./cros-ec-i2c-tunnel {})}/ssdt.cpio"
  ];

  # Enable the kernel driver
  boot.kernelPatches = [
    {
      name = "cros-ec-i2c-tunnel";
      patch = null;
      structuredExtraConfig = {
        I2C_CROS_EC_TUNNEL = lib.kernel.module;
      };
    }
  ];

  # Ensure the module is loaded
  boot.kernelModules = [ "i2c-cros-ec-tunnel" ];
}
