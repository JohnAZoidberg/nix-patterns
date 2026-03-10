# Override a package source (even in services)
# In this case fwupd
{ config, pkgs, ... }:

{
  imports = [
  ];

  nixpkgs = {
    overlays = [
      (final: prev: {
        fwupd = prev.fwupd.overrideAttrs (oldAttrs: {
	  # This may fail if the package in nixpkgs has patches that are
	  # incompatible with the new sources
	  version = "2.0.20";
          src = prev.fetchFromGitHub {
            owner = "fwupd";
            repo = "fwupd";
            tag = "2.0.20";
            hash = "sha256-6Wod4aIjb0Slyb45y5b5iSMelqgRuhiiV/NCCx3lRCQ=";
          };
        });
      })
    ];
  };

  services.fwupd.enable = true;
  environment.systemPackages = with pkgs; [
    fwupd
  ];
}
