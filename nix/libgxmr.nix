{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
  ffmpeg,
  ffmpegthumbnailer,
  libdvdnav,
  libdvdread,
  mpv,
  libGL,
  dtk5core,
  dtk5widget,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libgxmr";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-movie-reborn";
    rev = "1e1f672204829a81397bb60ef5dc5e37b11fbe9c";
    hash = "sha256-xCKETSCXo6RIyOu4u2z3rldlOYUaqJSfRYiQJmVo6d4=";
  };

  cmakeDir = "../src/libgxmr";

  cmakeFlags = [
    (lib.cmakeBool "CMAKE_INCLUDE_CURRENT_DIR" true)
  ];

  postPatch = ''
    sed -i '1i cmake_minimum_required(VERSION 3.16)' src/libgxmr/CMakeLists.txt
    sed -i '3i configure_file(''${PROJECT_SOURCE_DIR}/../../config.h.in ''${PROJECT_BINARY_DIR}/config.h @ONLY)' \
      src/libgxmr/CMakeLists.txt

    substituteInPlace src/libgxmr/libgxmr.pc.in \
      --replace-fail 'prefix=/usr' 'prefix=@CMAKE_INSTALL_PREFIX@' \
      --replace-fail 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail 'includedir=''${prefix}/include/libgxmr' 'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@/libgxmr'
  '';

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  configurePhase = ''
    mkdir -p pkgconfig-stub
    sed 's/^Requires.private:.*/Requires.private:/' \
      "$(pkg-config --variable=pcfiledir mpv)/mpv.pc" > pkgconfig-stub/mpv.pc
    export PKG_CONFIG_PATH="$PWD/pkgconfig-stub''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"

    export CXXFLAGS="$CXXFLAGS -I$sourceRoot/src/libgxmr -I$sourceRoot/src/common"

    runHook preConfigure
    cmakeConfigurePhase
    runHook postConfigure
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtx11extras
    ffmpeg
    ffmpegthumbnailer
    libdvdnav
    libdvdread
    mpv
    libGL
    dtk5core
    dtk5widget
  ];

  meta = {
    description = "Qt5 preview library emitted by gxde-movie-reborn";
    homepage = "https://github.com/GXDE-OS/gxde-movie-reborn";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
