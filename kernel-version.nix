# Use different linux kernel versions
{ config, pkgs, lib, ... }:
{
  imports = [ ];

  # Latest stable (default)
  # Check what's the version (in nixpkgs repo)
  # nix eval .#linuxPackages_testing.kernel.version
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_testing;

  # boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  # Specific version
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_18;
}
