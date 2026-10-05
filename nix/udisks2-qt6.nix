{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "udisks2-qt6";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "udisks2-qt6";
    rev = "5bc6cd873138eba7de6be922e9b02a0df27b5c05";
    hash = "sha256-S1Wf8Vr98N3Bsx3Sxf45xeYE8KInsg3dDrrQ3c1kFMs=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace udisks2-qt6.pc.in \
      --replace-fail 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' 'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ qt6.qtbase ];

  meta = {
    description = "UDisks2 wrapper library for Qt6";
    homepage = "https://github.com/GXDE-OS/udisks2-qt6";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
