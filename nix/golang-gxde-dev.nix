{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "golang-gxde-dev";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "golang-gxde-dev";
    rev = "a1f09d503e56d75136b48074735082b15746efa0";
    hash = "sha256-/sL34RhijYBwIMA8+nWvpwJV0k+3MPTj+FC4FUXGMmU=";
  };

  patches = [ ./patches/golang-gxde-dev/0001-use-portable-alsa-header.patch ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gocode-gxde/src
    cp -a gocode/. $out/share/gocode-gxde/src/

    install -Dm644 LICENSE $out/share/licenses/golang-gxde-dev/LICENSE
    install -Dm644 debian/copyright $out/share/licenses/golang-gxde-dev/copyright

    runHook postInstall
  '';

  meta = {
    description = "Curated GOPATH sources used by GXDE's Go components";
    homepage = "https://github.com/GXDE-OS/golang-gxde-dev";
    license = [
      lib.licenses.gpl3Plus
      lib.licenses.asl20
      lib.licenses.bsd2
      lib.licenses.bsd3
      lib.licenses.mit
      lib.licenses.isc
    ];
    platforms = lib.platforms.linux;
  };
})
