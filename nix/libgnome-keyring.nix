{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  intltool,
  libtool,
  gobject-introspection,
  vala,
  glib,
  dbus,
  libgcrypt,
  libgpg-error,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libgnome-keyring";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "libgnome-keyring";
    rev = "815d0a689779da16f015f335b78653130f345111";
    hash = "sha256-B/L8/sRNnEHU6jgJKhKvolID/nQtyWLwgsy01Een26Y=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
    intltool
    libtool
    gobject-introspection
    vala
  ];

  buildInputs = [
    glib
    dbus
    libgcrypt
    libgpg-error
  ];

  env.GPGRT_CONFIG = "${lib.getDev libgpg-error}/bin/gpgrt-config";

  configureFlags = [
    "--disable-static"
    "--disable-gtk-doc"
    "--enable-introspection"
    "--enable-vala"
  ];

  meta = {
    description = "GNOME Keyring compatibility library maintained by GXDE";
    homepage = "https://github.com/GXDE-OS/libgnome-keyring";
    license = with lib.licenses; [ lgpl2Plus gpl2Plus ];
    platforms = lib.platforms.linux;
  };
})
