{
  lib,
  stdenv,
  fetchFromGitHub,
  wayland-scanner,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wlr-protocols";
  version = "0.0+git20231016-0deepin";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "wlr-protocols";
    rev = "1670ddb24f0da098105a247331456d15fe4de3f6";
    hash = "sha256-lGK2WlJ4yJhzlMMCx2PN2IaFoa5gcyxO6GTnKKiRjGs=";
  };

  nativeBuildInputs = [ wayland-scanner ];

  dontConfigure = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "DATADIR=${placeholder "out"}/share"
    "DATAROOTDIR=${placeholder "out"}/share"
  ];

  meta = {
    description = "wlroots Wayland protocol descriptions used by GXDE";
    homepage = "https://github.com/GXDE-OS/wlr-protocols";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
