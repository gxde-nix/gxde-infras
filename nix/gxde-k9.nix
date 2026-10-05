{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  coreutils,
  newt,
  util-linux,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-k9";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-k9";
    rev = "c35100d1c83481542b91244de97cd7ebb7a5db6e";
    hash = "sha256-+EwVdtzKTNTpTPB/joZEewES6qw8dWTc/gVVMYxCjy4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    substituteInPlace src/usr/bin/gxde-k9 src/usr/bin/gxde-k9-chocker \
      --replace-fail '/usr/share/gxde-k9' '${placeholder "out"}/share/gxde-k9'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 src/usr/bin/gxde-k9 -t $out/bin/
    install -Dm755 src/usr/bin/gxde-k9-chocker -t $out/bin/
    install -d $out/share
    cp -a src/usr/share/gxde-k9 $out/share/gxde-k9
    install -Dm644 src/etc/xdg/autostart/gxde-k9.desktop \
      $out/etc/xdg/autostart/gxde-k9.desktop
    install -Dm644 src/usr/share/bash-completion/completions/gxde-k9 \
      $out/share/bash-completion/completions/gxde-k9

    for prog in gxde-k9 gxde-k9-chocker; do
      wrapProgram $out/bin/$prog \
        --prefix PATH : ${lib.makeBinPath [ bash coreutils newt util-linux ]}
    done

    runHook postInstall
  '';

  meta = {
    description = "GXDE service runner (K9)";
    homepage = "https://github.com/GXDE-OS/gxde-k9";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gxde-k9";
  };
})
