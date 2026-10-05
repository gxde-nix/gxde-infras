{
  lib,
  stdenv,
  fetchFromGitHub,
  go,
  python3,
  pkg-config,
  gtk3,
  poppler,
  libcanberra,
  gdk-pixbuf,
  gdk-pixbuf-xlib,
  librsvg,
  cairo,
  libgudev,
  alsa-lib,
  pulseaudio,
  libX11,
  libXcursor,
  libXfixes,
  libXi,
  golang-gxde-dev,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-api";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-api";
    rev = "342ace9c26d483683a01a7cec9022e4f3292c905";
    hash = "sha256-IyUn1uK2+Z4SeIawlc1VCZbBe2co8ehrTXOWiXawk0M=";
  };

  patches = [
    ./patches/gxde-api/0001-fedora-package-queries.patch
    ./patches/gxde-api/0002-build-pie-executables.patch
    ./patches/gxde-api/0003-prepare-before-parallel-build.patch
  ];

  nativeBuildInputs = [
    go
    python3
    pkg-config
  ];

  buildInputs = [
    gtk3
    poppler
    libcanberra
    gdk-pixbuf
    gdk-pixbuf-xlib
    librsvg
    cairo
    libgudev
    alsa-lib
    pulseaudio
    libX11
    libXcursor
    libXfixes
    libXi
  ];

  postPatch = ''
    cp ${./files/gxde-api/compile-policy-translations.py} compile-policy-translations.py
  '';

  gopath = lib.concatStringsSep ":" [
    "${golang-gxde-dev}/share/gocode-gxde"
    "$PWD/gopath"
  ];

  buildPhase = ''
    runHook preBuild

    export GO111MODULE=off
    export GOPROXY=off
    export GOTOOLCHAIN=local
    export GOFLAGS="-trimpath -buildvcs=false"
    export GOCACHE="$TMPDIR/gocache"
    export CGO_CFLAGS="$CFLAGS -std=gnu17"
    export CGO_LDFLAGS="$LDFLAGS"

    python3 compile-policy-translations.py

    make build-binary build-dev GOPATH="${finalAttrs.gopath}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make install \
      GOPATH="${finalAttrs.gopath}" \
      DESTDIR=$out \
      PREFIX= \
      SYSTEMD_SERVICE_DIR=$out/lib/systemd/system

    runHook postInstall
  '';

  meta = {
    description = "GXDE system API daemons and helpers";
    homepage = "https://github.com/GXDE-OS/gxde-api";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
