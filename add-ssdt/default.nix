{
  stdenv,
  acpica-tools,
  cpio
}:

stdenv.mkDerivation {
  name = "custom-ssdt";
  # ssdt.dsl is stored here
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

    cp ssdt.aml kernel/firmware/acpi/SSDT.aml
    find kernel | cpio -H newc --create > $out/ssdt.cpio
  '';
}
