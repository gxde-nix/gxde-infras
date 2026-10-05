{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dframework-dbus-qt6";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "dframework-dbus-qt6";
    rev = "eb1cbe497b32b500298c7b98cfadd42cbc2ac30a";
    hash = "sha256-GJLbCaD9/zWti6+M5dH6DAw13QWN74Fg5PdvoallxZs=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  patches = [ ./patches/dframework-dbus-qt6/0001-fedora-build.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [ qt6.qtbase ];

  meta = {
    description = "Deepin D-Bus interface framework (Qt6)";
    homepage = "https://github.com/GXDE-OS/dframework-dbus-qt6";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
