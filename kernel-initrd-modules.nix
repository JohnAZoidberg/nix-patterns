# Load extra modules in initrd
# Useful to force some modules to load early
{ config, pkgs, lib, ... }:
{
  imports = [ ];

  # Additional modules for Laptop 12 touchscreen/touchpad in initrd
  # E.g. for unl0kr on-screen keyboard
  boot.initrd.kernelModules = [
    "pinctrl_intel_platform"
    "intel_lpss_pci"
    "i2c_hid_acpi"
    "i2c_hid"
    "hid_multitouch"
    "hid_generic"
  ];
}
