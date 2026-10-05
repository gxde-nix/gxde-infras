{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  ffmpeg,
  ffmpegthumbnailer,
  libdvdcss,
  libdvdnav,
  libdvdread,
  mpv,
  pulseaudio,
  openssl,
  libGL,
  libX11,
  libXext,
  libXtst,
  libxcb-util,
  libxcb-wm,
  xcb-proto,
  dtk2widget-qt6,
  dtk6core,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-movie-reborn";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-movie-reborn";
    rev = "1e1f672204829a81397bb60ef5dc5e37b11fbe9c";
    hash = "sha256-xCKETSCXo6RIyOu4u2z3rldlOYUaqJSfRYiQJmVo6d4=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  patches = [
    ./patches/gxde-movie-reborn/0001-find-qt6-gui-private.patch
    ./patches/gxde-movie-reborn/0002-find-qt6-gui-private-in-library.patch
    ./patches/gxde-movie-reborn/0003-preserve-distribution-compiler-flags-in-test.patch
  ];

  postPatch = ''
    sed -i '/^add_subdirectory(libgxmr)$/d' src/CMakeLists.txt

    substituteInPlace src/libgxmr-qt6/libgxmr-qt6.pc.in \
      --replace-fail 'prefix=/usr' 'prefix=@CMAKE_INSTALL_PREFIX@' \
      --replace-fail 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' 'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail 'includedir=''${prefix}/include/libgxmr-qt6' 'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@/libgxmr-qt6'
  '';

  configurePhase = ''
    mkdir -p pkgconfig-stub
    sed 's/^Requires.private:.*/Requires.private:/' \
      "$(pkg-config --variable=pcfiledir mpv)/mpv.pc" > pkgconfig-stub/mpv.pc
    export PKG_CONFIG_PATH="$PWD/pkgconfig-stub''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"

    runHook preConfigure
    cmakeConfigurePhase
    runHook postConfigure
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    ffmpeg
    ffmpegthumbnailer
    libdvdcss
    libdvdnav
    libdvdread
    mpv
    pulseaudio
    openssl
    libGL
    libX11
    libXext
    libXtst
    libxcb-util
    libxcb-wm
    xcb-proto
    dtk2widget-qt6
    dtk6core
  ];

  cmakeFlags = [
    (lib.cmakeBool "CMAKE_DISABLE_FIND_PACKAGE_Qt5LinguistTools" false)
  ];

  meta = {
    description = "GXDE movie player and its libgxmr-qt6 preview library (Qt6 half)";
    homepage = "https://github.com/GXDE-OS/gxde-movie-reborn";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
