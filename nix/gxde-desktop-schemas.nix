{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-desktop-schemas";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-desktop-schemas";
    rev = "f9a92f39dbd3d4956075e6a15b790d5dd8074a92";
    hash = "sha256-sjo09sDKUCvScnEiSDs1JTV7Z0Jw3GHd7wo6Pf84A50=";
  };

  nativeBuildInputs = [
    glib
    python3
  ];

  dontConfigure = true;

  distroFlavour = if stdenv.hostPlatform.isAarch64 then "arm" else "x86";

  makeFlags = [ "DISTRO=${finalAttrs.distroFlavour}" ];

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = {
    description = "GXDE desktop GSettings schemas and overrides";
    homepage = "https://github.com/GXDE-OS/gxde-desktop-schemas";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
