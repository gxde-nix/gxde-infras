{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  libisoburn,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "disomaster-qt6";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "disomaster-qt6";
    rev = "87ce9fcd4a352bd06bd09f6180ca7bdb2df941d6";
    hash = "sha256-ms6IQRSDC/jseAALpheaCBTX0Zq4P/M0i8PXq5aFaKo=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  patches = [ ./patches/disomaster-qt6/0001-fedora-build.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    libisoburn
  ];

  meta = {
    description = "Deepin ISO mastering library (Qt6 port)";
    homepage = "https://github.com/GXDE-OS/disomaster-qt6";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
