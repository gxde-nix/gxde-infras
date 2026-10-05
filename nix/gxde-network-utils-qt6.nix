{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt6,
  dframework-dbus-qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-network-utils-qt6";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-network-utils-qt6";
    rev = "cfa815fd7e9b2b0ef64a2d2d6cfc1d0fada2895b";
    hash = "sha256-Y0RwwrpufoRuR+hBA/RNEMeKR9rbC0s+CXJmMumVtuQ=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  patches = [ ./patches/gxde-network-utils-qt6/0001-fedora-qmake-paths.patch ];

  postPatch = ''
    patchShebangs .
    chmod +x translate_generation.sh
  '';

  nativeBuildInputs = [
    pkg-config
    qt6.qtbase
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    dframework-dbus-qt6
  ];

  preConfigure = ''
    export DFRAMEWORK_PATH=${dframework-dbus-qt6.dev}
  '';

  configurePhase = ''
    runHook preConfigure

    qmake6 dde-network-utils.pro \
      PREFIX=$out \
      LIB_INSTALL_DIR=$out/lib \
      MKSPECS_INSTALL_DIR=$out/lib/qt6/mkspecs

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    make install INSTALL_ROOT=

    runHook postInstall
  '';

  postInstall = ''
    moveToOutput "include" "$dev"
    moveToOutput "lib/pkgconfig" "$dev"
  '';

  meta = {
    description = "GXDE network utilities library (Qt6 port)";
    homepage = "https://github.com/GXDE-OS/gxde-network-utils-qt6";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
