# For USB3 Debugging and shell with special debug cable
# See: https://docs.kernel.org/driver-api/usb/usb3-debug-port.html
#
# Will rebuild the whole kernel! Takes at least half an hour
#
# Creates /dev/ttyDBC0 on the target device
#
# Hardware needed: USB 3.0 SuperSpeed A-to-A debug cable
#
# On the host (other machine), the target appears as /dev/ttyUSB0.
# Use: picocom /dev/ttyUSB0 -b 115200
# The host needs CONFIG_USB_SERIAL_DEBUG=m
# This is included in most distro kernels
{ config, pkgs, lib, ... }:
{
  imports = [ ];

  boot.kernelPatches = [
    {
      name = "usb3-debugging";
      patch = null;
      structuredExtraConfig = {
        EARLY_PRINTK_USB_XDBC = lib.kernel.yes;
        USB_XHCI_DBGCAP = lib.kernel.yes;
      };
    }
  ];

  boot.kernelParams = [
    # Early boot logs over USB3 debug port (before console init)
    "earlyprintk=xdbc"
    # Keep early console alive after regular console starts
    "earlyprintk=xdbc,keep"
    # Kernel console on DbC TTY
    "console=ttyDBC0"
    # Prevent USB autosuspend from breaking the debug connection
    "usbcore.autosuspend=-1"
  ];

  # Login shell on the USB debug port
  systemd.services."serial-getty@ttyDBC0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };
}
