# Modify the linux modprobe configuration (module loading parameters)
{ config, pkgs, lib, ... }:
{
  imports = [ ];

  # Force loading SOF
  boot.extraModprobeConfig = ''
    options snd_intel_dspcfg dsp_driver=3
  '';
}
