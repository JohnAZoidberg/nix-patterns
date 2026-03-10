# Patch a package (even in services)
# In this case libfprint
{ config, pkgs, ... }:

{
  imports = [
  ];

  nixpkgs = {
    overlays = [
      (final: prev: {
        libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or []) ++ [
	    # Sample patch
            (prev.fetchpatch {
              url = "https://gitlab.freedesktop.org/libfprint/libfprint/-/commit/a9c6621119e9eeeacf5d67cfb25ee22c36274d9c.patch";
              hash = "sha256-x2MyN4dOLNe33eukKmS3mBZrdEMBmINtsAkZ8JzFlrU=";
	    })
	  ];
	});
      })
    ];
  };

  services.fprintd.enable = true;
  environment.systemPackages = with pkgs; [
    fprintd
  ];
}
