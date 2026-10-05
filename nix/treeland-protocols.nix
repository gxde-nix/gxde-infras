{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  wayland-scanner,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "treeland-protocols";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "treeland-protocols";
    rev = "95b9c35d97f2e4584854290db97018e8fa13bc73";
    hash = "sha256-fsYtb4P0V10o1+ULNLYme1jJ5ztdqXz9FOdp/9qWioU=";
  };

  nativeBuildInputs = [
    cmake
    wayland-scanner
  ];

  meta = {
    description = "Treeland Wayland protocol descriptions";
    homepage = "https://github.com/GXDE-OS/treeland-protocols";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
