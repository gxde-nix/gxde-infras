{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libdbusmenu-qt6";
  version = "0.9.3+16.04.20160218";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "libdbusmenu-qt6";
    rev = "5b35566625081592fd8f20f71c283b948a71b0de";
    hash = "sha256-xzBzeAwKwCfAR+Wcy/Wc+qmo39Il+4uoDl+hwu93jdg=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  patches = [ ./patches/libdbusmenu-qt6/0001-fedora-build.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ qt6.qtbase ];

  cmakeFlags = [
    (lib.cmakeBool "USE_QT6" true)
    (lib.cmakeBool "WITH_DOC" false)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  meta = {
    description = "Qt implementation of the DBusMenu protocol (Qt6)";
    homepage = "https://github.com/GXDE-OS/libdbusmenu-qt6";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
