# Add custom udev rules
{ config, pkgs, lib, ... }:
{
  imports = [ ];

  services.udev = {
    # From qmk_firmware util/udev/50-qmk.rules
    extraRules = ''
      ## QMK HID
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2067", TAG+="uaccess"
    '';
  };
}
