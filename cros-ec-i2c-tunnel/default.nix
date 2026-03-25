{
  stdenv,
  acpica-tools,
  cpio
}:

stdenv.mkDerivation {
  name = "cros-ec-i2c-tunnel-ssdt";
  src = ./.;

  phases = [ "unpackPhase" "installPhase" ];

  nativeBuildInputs = [
    acpica-tools
    cpio
  ];

  installPhase = ''
    mkdir -p $out/
    mkdir -p kernel/firmware/acpi

    iasl -p ./ssdt -sa $src/ssdt.dsl

    cp ssdt.aml kernel/firmware/acpi/ssdt-ec-tunnel.aml
    find kernel | cpio -H newc --create > $out/ssdt.cpio
  '';
}
