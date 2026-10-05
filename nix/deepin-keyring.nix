{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "deepin-keyring";
  version = "2019.01.09";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "deepin-keyring";
    rev = "1017a81b1451d12ab4e94bd24e3413150c7f3974";
    hash = "sha256-IhtMENt6odA6xxFUyc2x2CCHK489rCUxX0+bprUoFsg=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 keyrings/*.gpg -t $out/share/keyrings/
    install -Dm644 debian/copyright $out/share/licenses/deepin-keyring/copyright

    runHook postInstall
  '';

  meta = {
    description = "Deepin archive keyring used by GXDE";
    homepage = "https://github.com/GXDE-OS/deepin-keyring";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
