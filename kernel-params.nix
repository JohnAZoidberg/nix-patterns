# Add kernel commandline parameters
# This will be merged with parameters specified in other places (NixOS modules)
{ config, pkgs, lib, ... }:
{
  # Some common options, quiet booting and enable serial console at ttyS0
  boot.kernelParams = [ "quiet" "console=ttyS0,115200n8" ];
}
