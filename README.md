# NixOS Module Patterns

Standalone NixOS module examples for kernel configuration, patches, overlays, firmware, and more.

## Patterns

- **kernel-config.nix** — Recompile the kernel with a config change (e.g. `USB4_DEBUGFS_WRITE`)
- **kernel-initrd-modules.nix** — Force-load modules in initrd
- **kernel-modprobe-config.nix** — Change modprobe parameters for kernel modules
- **kernel-patch-module.nix** — Patch a single kernel module without rebuilding the whole kernel
- **kernel-patch.nix** — Patch the whole kernel
- **kernel-version.nix** — Use a specific kernel version
- **linux-firmware.nix** — Add binaries to linux-firmware (`/lib/firmware`)
- **package-overlay-patches.nix** — Add patches to a package
- **package-overlay-src.nix** — Change a package source
- **patch-acpi-tables.nix** — Add or override ACPI tables

## CI & Validation

Every module is checked for correct evaluation on push and PR via GitHub Actions.

### Run checks locally

```sh
nix flake check
```

This evaluates each module in a minimal NixOS context and validates expected properties (kernel patches present, initrd modules listed, modprobe config correct, firmware files exist, overlays applied).

### Build the ISO

```sh
nix build .#iso
```

Produces a bootable NixOS ISO with all compatible patterns applied.

### Boot the ISO in a VM

```sh
qemu-system-x86_64 -cdrom result/iso/*.iso -m 2G
```

### Per-pattern live system validation

On a running NixOS system with these modules applied:

```sh
# Kernel config
zcat /proc/config.gz | grep USB4_DEBUGFS_WRITE

# Kernel version
uname -r

# Initrd modules
cat /etc/modprobe.d/*.conf

# Modprobe config
cat /etc/modprobe.d/*.conf | grep snd_intel_dspcfg

# Firmware files
ls /lib/firmware/ibt-0041-0041.sfi /lib/firmware/iwlwifi-ty-a0-gf-ao-89.ucode

# Package overlay (fwupd version)
fwupd --version
```
