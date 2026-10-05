{ pkgs, dtk5, dtk6, dtk2 }:

let
  inherit (pkgs) lib;

  dtk5core = dtk5.dtk5core;
  dtk5widget = dtk5.dtk5widget;
  dtk2core = dtk2.dtk2core;
  dtk2widget = dtk2.dtk2widget;
  dtk2widget-qt6 = dtk2.dtk2widget-qt6;
  dtk6core = dtk6.dtk6core;
  dtk6widget = dtk6.dtk6widget;
  dtk6declarative = dtk6.dtk6declarative;

  golang-gxde-dev = pkgs.callPackage ./nix/golang-gxde-dev.nix { };

  gxde-k9 = pkgs.callPackage ./nix/gxde-k9.nix { };

  gxde-api = pkgs.callPackage ./nix/gxde-api.nix {
    inherit golang-gxde-dev;
  };

  disomaster-qt6 = pkgs.callPackage ./nix/disomaster-qt6.nix { };

  deepin-keyring = pkgs.callPackage ./nix/deepin-keyring.nix { };

  libgnome-keyring = pkgs.callPackage ./nix/libgnome-keyring.nix { };

  gxde-desktop-base = pkgs.callPackage ./nix/gxde-desktop-base.nix { };

  gxde-desktop-schemas = pkgs.callPackage ./nix/gxde-desktop-schemas.nix { };

  dframework-dbus-qt6 = pkgs.callPackage ./nix/dframework-dbus-qt6.nix { };

  gxde-network-utils-qt6 = pkgs.callPackage ./nix/gxde-network-utils-qt6.nix {
    inherit dframework-dbus-qt6;
  };

  udisks2-qt6 = pkgs.callPackage ./nix/udisks2-qt6.nix { };

  libdbusmenu-qt6 = pkgs.callPackage ./nix/libdbusmenu-qt6.nix { };

  wlr-protocols = pkgs.callPackage ./nix/wlr-protocols.nix { };

  treeland-protocols = pkgs.callPackage ./nix/treeland-protocols.nix { };

  xdg-desktop-portal-gxde = pkgs.callPackage ./nix/xdg-desktop-portal-gxde.nix {
    inherit dtk6widget dtk6declarative treeland-protocols wlr-protocols;
  };

  gxde-movie-reborn-qt6 = pkgs.callPackage ./nix/gxde-movie-reborn.nix {
    inherit dtk2widget-qt6 dtk6core;
  };

  libgxmr = pkgs.callPackage ./nix/libgxmr.nix {
    inherit dtk5core dtk5widget;
  };

  gxde-movie-reborn = pkgs.symlinkJoin {
    name = "gxde-movie-reborn-${gxde-movie-reborn-qt6.version}";
    paths = [
      gxde-movie-reborn-qt6
      (lib.getDev gxde-movie-reborn-qt6)
      libgxmr
      (lib.getDev libgxmr)
    ];
  };

  modules = [
    golang-gxde-dev
    gxde-k9
    gxde-api
    disomaster-qt6
    deepin-keyring
    libgnome-keyring
    gxde-desktop-base
    gxde-desktop-schemas
    dframework-dbus-qt6
    gxde-network-utils-qt6
    udisks2-qt6
    libdbusmenu-qt6
    wlr-protocols
    treeland-protocols
    xdg-desktop-portal-gxde
    gxde-movie-reborn
  ];

  all = pkgs.symlinkJoin {
    name = "gxde-infras-${gxde-desktop-schemas.version}";
    paths = lib.concatMap (p: [ p (lib.getDev p) ]) modules;
  };
in
{
  inherit
    golang-gxde-dev
    gxde-k9
    gxde-api
    disomaster-qt6
    deepin-keyring
    libgnome-keyring
    gxde-desktop-base
    gxde-desktop-schemas
    dframework-dbus-qt6
    gxde-network-utils-qt6
    udisks2-qt6
    libdbusmenu-qt6
    wlr-protocols
    treeland-protocols
    xdg-desktop-portal-gxde
    gxde-movie-reborn
    libgxmr
    all
    ;

  gxde-infras = all;

  default = all;
}
