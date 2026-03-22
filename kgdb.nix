# Kernel debugging over USB3 debug cable using kgdb (GDB) and kdb
# See: https://docs.kernel.org/process/debugging/kgdb.html
# See: https://docs.kernel.org/driver-api/usb/usb3-debug-port.html
#
# Imports usb3-debug.nix for the USB3 debug cable transport (ttyDBC0)
# Will rebuild the whole kernel!
#
# Provides two debuggers:
#
#   kgdb - source-level debugging with GDB (like WinDbg on Windows)
#     Set breakpoints, step through code, inspect variables/memory
#
#   kdb - built-in kernel shell debugger (simpler, no GDB needed)
#     Commands: bt, ps, dmesg, lsmod, go, help
#     Enter with SysRq-G, type commands directly over the serial link
#
# === Usage (on the target) ===
#
# Break into the debugger at any time:
#   echo g > /proc/sysrq-trigger
#
# To break at boot, uncomment "kgdbwait" below
#
# === Usage (on the host) ===
#
# Connect with GDB:
#   gdb ./vmlinux
#   (gdb) target remote /dev/ttyUSB0
#
# Or use kdb directly (no GDB needed):
#   picocom /dev/ttyUSB0 -b 115200
#   # then trigger SysRq-G on target, you get a kdb> prompt
#
# Switch between kgdb and kdb:
#   kgdb -> kdb: type $3#33 in gdb, or: maintenance packet 3
#   kdb -> kgdb: type "kgdb" at the kdb> prompt
#
# Run kdb commands from inside GDB:
#   (gdb) monitor ps
#   (gdb) monitor dmesg
#   (gdb) monitor lsmod
#
# === Important notes ===
#
# - Do NOT add "kgdbcon" when console= and kgdboc= use the same TTY
# - nokaslr is required so GDB can resolve kernel symbols
# - STRICT_KERNEL_RWX is disabled to allow software breakpoints
#   (alternatively, use only hardware breakpoints: hbreak in GDB)
#
{ config, pkgs, lib, ... }:
{
  imports = [
    ./usb3-debug.nix
  ];

  boot.kernelPatches = [
    {
      name = "kgdb";
      patch = null;
      structuredExtraConfig = {
        # Core kgdb support — the GDB stub that speaks GDB remote protocol
        KGDB = lib.kernel.yes;
        # I/O driver that lets kgdb communicate over serial TTYs (ttyDBC0, ttyS0, etc.)
        KGDB_SERIAL_CONSOLE = lib.kernel.yes;
        # kdb: built-in debugger shell (bt, ps, dmesg, lsmod, etc.)
        # Works over the same serial link without needing GDB on the host
        KGDB_KDB = lib.kernel.yes;
        # Include debug symbols in vmlinux so GDB can resolve functions/variables
        DEBUG_INFO = lib.kernel.yes;
        # Preserve frame pointers for more accurate stack traces in GDB
        # May conflict with ORC unwinder on x86_64 — drop this if build fails
        FRAME_POINTER = lib.kernel.yes;
        # Enable SysRq key combos — needed to trigger SysRq-G to break into debugger
        MAGIC_SYSRQ = lib.kernel.yes;
        # Makes kernel text read-only and non-text non-executable (security hardening)
        # Must be disabled for kgdb software breakpoints (int3) to work, since
        # GDB needs to write into kernel text to insert breakpoint instructions.
        # Alternative: leave enabled and use hardware breakpoints only (hbreak in GDB)
        # mkForce needed because NixOS base kernel config enables this by default
        STRICT_KERNEL_RWX = lib.mkForce lib.kernel.no;
      };
    }
  ];

  boot.kernelParams = [
    "kgdboc=ttyDBC0"
    "nokaslr"
    # Uncomment to wait for debugger at boot:
    # "kgdbwait"
  ];
}
