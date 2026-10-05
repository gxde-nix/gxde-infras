{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  kdePackages,
  qt6,
  libdrm,
  libgbm,
  pipewire,
  wayland,
  wayland-scanner,
  wayland-protocols,
  dtk6widget,
  dtk6declarative,
  treeland-protocols,
  wlr-protocols,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-gxde";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "xdg-desktop-portal-gxde";
    rev = "410c257624988d8944a634c16acbc0c6fddcca2d";
    hash = "sha256-G+j+tFeVS5zy19E1BlFso4UXK2AkuGZ/OSQJLt7e/Ys=";
  };

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace src/wayland/CMakeLists.txt \
      --replace-fail '/usr/share/wayland/wayland.xml' '${wayland-scanner}/share/wayland/wayland.xml'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    kdePackages.extra-cmake-modules
    qt6.qttools
    wayland-scanner
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    libdrm
    libgbm
    pipewire
    wayland
    wayland-protocols
    dtk6widget
    dtk6declarative
    treeland-protocols
    wlr-protocols
  ];

  meta = {
    description = "XDG Desktop Portal implementation for GXDE";
    homepage = "https://github.com/GXDE-OS/xdg-desktop-portal-gxde";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
