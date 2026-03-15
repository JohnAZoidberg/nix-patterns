# Add custom udev hwdb entries
{ config, pkgs, lib, ... }:
{
  services.udev = {
    # Already upstreamed since 2023, just an example
    extraHwdb = ''
      # HDMI Expansion Card
      usb:v32ACp0002*
      # DisplayPort Expansion Card
      usb:v32ACp0003*
        ID_AUTOSUSPEND=1
    '';
  };
}
