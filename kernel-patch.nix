# Patch the kernel (or a built-in module)
# Will rebuild the whole kernel! Takes at least half an hour
{ config, pkgs, lib, ... }:
{
  imports = [ ];

  boot.kernelPatches = [
    # Sample patch
    {
      name = "ucsi-noerror";
      patch = (pkgs.fetchpatch {
        url = "https://github.com/FrameworkComputer/linux/commit/00125504f43fef9a671b0d6608bb0f458896103d.patch";
        hash = "sha256-QQ0i0QHHRCPQVwWqGrO61j6T7Sip8lQAuVK2KRAu0zw=";
      });
    }
  ];
}
