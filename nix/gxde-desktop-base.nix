{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-desktop-base";
  version = "2026.10.04";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-desktop-base";
    rev = "361f74ed28eb50542c97924b7132b16394fe3194";
    hash = "sha256-zxdwDvDNHNMPfe+ynG6fuPlZWN68MQ1xeY9/rBKzzkI=";
  };

  patches = [ ./patches/gxde-desktop-base/0001-scope-fedora-session-defaults.patch ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dpm0644 files/desktop-version-lizhi $out/lib/deepin/desktop-version
    printf 'lizhi\n' > $out/lib/deepin/gxde-codename
    ln -s /usr/lib/os-release $out/lib/deepin/os-release

    for json in i18n_dependent language_info; do
      install -Dpm0644 "files/$json.json" "$out/share/i18n/$json.json"
    done

    install -Dpm0644 distribution.info $out/share/deepin/distribution.info
    cp -a distribution $out/share/deepin/
    install -Dpm0644 files/deepin-logo.png $out/share/plymouth/deepin-logo.png

    install -Dpm0644 gxde.sh $out/etc/profile.d/gxde.sh
    install -Dpm0755 gxde-config-after-desktop $out/bin/gxde-config-after-desktop
    install -Dpm0644 gxde-config-after-desktop.desktop \
      $out/etc/xdg/autostart/gxde-config-after-desktop.desktop
    printf '\nOnlyShowIn=GXDE;Deepin;DDE;\n' \
      >> $out/etc/xdg/autostart/gxde-config-after-desktop.desktop

    install -Dm644 LICENSE $out/share/licenses/gxde-desktop-base/LICENSE

    runHook postInstall
  '';

  meta = {
    description = "GXDE desktop identity, distribution metadata and session defaults";
    homepage = "https://github.com/GXDE-OS/gxde-desktop-base";
    license = with lib.licenses; [ gpl3Plus cc-by-40 ];
    platforms = lib.platforms.linux;
  };
})
