# Add or override an ACPI table
# Either provide a new ACPI table
# Or extract one, decompile it and increase the version number to override it
#
# This example adds a new SSDT, but you can also override the main DSDT
{ config, pkgs, lib, ... }:
{
  imports = [
  ];

  boot.initrd.prepend = [
    "${(pkgs.callPackage ./add-ssdt {})}/ssdt.cpio"
  ];
}
