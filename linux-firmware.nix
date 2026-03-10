# Add more firmware files into /lib/firmware
# For example for unreleased hardware
# Here an example with the stable AX210 module
{ config, pkgs, lib, ... }:
{
  imports = [ ];

  hardware.firmware = [
    (
      let 
        ax210-firmware = pkgs.stdenv.mkDerivation {
          name = "database";
          src = ./ax210-linux-firmware/.;
          phases = [ "unpackPhase" "installPhase" ];
          installPhase = ''
            mkdir -p $out
            cp -r $src/* $out/
          '';
        };
      in
      pkgs.runCommand "firmware-ax210" { } ''
        mkdir -p $out/lib/firmware
        mkdir -p $out/lib/firmware/intel
        cp ${ax210-firmware}/ibt-0041-0041.sfi $out/lib/firmware/
        cp ${ax210-firmware}/iwlwifi-ty-a0-gf-ao-89.ucode $out/lib/firmware
        cp ${ax210-firmware}/iwlwifi-ty-a0-gf-ao-89.ucode $out/lib/firmware/intel/iwlwifi
      ''
    )
  ];
}
