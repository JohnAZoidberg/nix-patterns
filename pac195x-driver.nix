{ lib, stdenv, kernel, ... }:
stdenv.mkDerivation {
  pname = "pac195x";
  version = "0.1";
  src = ./.; # placeholder
  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];
  # Stub: skip build since there is no real source
  dontBuild = true;
  installPhase = "mkdir -p $out";
  meta.license = lib.licenses.gpl2Only;
}
