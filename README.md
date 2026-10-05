# GXDE Infras
Infrastructures for GXDE desktop environment: Go sources, the service runner, Qt6 libraries, desktop metadata, schemas, protocol descriptions and the XDG desktop portal.

## Version
| flake attr | Upstream | pin | out | dev |
| --- | --- | --- | --- | --- |
| `golang-gxde-dev` | GXDE-OS/golang-gxde-dev | tag `1.0.6` | `share/gocode-gxde/src` | — |
| `gxde-k9` | GXDE-OS/gxde-k9 | tag `2.0.0` | `bin/gxde-k9{,-chocker}`, `share/gxde-k9`, `etc/xdg/autostart` | — |
| `gxde-api` | GXDE-OS/gxde-api | tag `4.0.6` | `bin/dde-open`, `lib/deepin-api`, `share/dbus-1`, `share/polkit-1`, `share/gxde-api`, `var/lib/polkit-1` | — |
| `disomaster-qt6` | GXDE-OS/disomaster-qt6 | tag `1.0.0-gxde2` | `libdisomaster6.so.1*` | `include/disomaster-qt6`, `disomaster-qt6.pc` |
| `deepin-keyring` | GXDE-OS/deepin-keyring | `master` (no tags) | `share/keyrings/*.gpg` | — |
| `libgnome-keyring` | GXDE-OS/libgnome-keyring | tag `3.12.0-3` | `libgnome-keyring.so.3*`, typelib | `include/gnome-keyring-1`, `gnome-keyring-1.pc`, gir, vapi |
| `gxde-desktop-base` | GXDE-OS/gxde-desktop-base | tag `2026.10.04` | `lib/deepin`, `share/deepin`, `share/i18n`, `etc/profile.d`, `etc/xdg/autostart` | — |
| `gxde-desktop-schemas` | GXDE-OS/gxde-desktop-schemas | tag `4.0.7` | `share/glib-2.0/schemas`, `share/deepin-appstore` | — |
| `dframework-dbus-qt6` | GXDE-OS/dframework-dbus-qt6 | tag `6.0.1-gxde3` | `libdframeworkdbus-qt6.so.6*` | `include/libdframeworkdbus-qt6-6.0`, cmake |
| `gxde-network-utils-qt6` | GXDE-OS/gxde-network-utils-qt6 | tag `6.0.1` | `libgxde-network-utils-qt6.so.*`, translations | `include/libgxde-network-utils-qt6`, pc |
| `udisks2-qt6` | GXDE-OS/udisks2-qt6 | tag `6.0.1` | `libudisks2-qt6.so.*` | `include/udisks2-qt6`, pc, cmake |
| `libdbusmenu-qt6` | GXDE-OS/libdbusmenu-qt6 | tag `0.9.3+16.04.20160218-6` | `libdbusmenu-qt6.so.*` | `include/dbusmenu-qt6`, pc, cmake |
| `wlr-protocols` | GXDE-OS/wlr-protocols | tag `0.0+git20231016-0deepin` | `share/wlr-protocols`, `share/pkgconfig` | — |
| `treeland-protocols` | GXDE-OS/treeland-protocols | tag `0.5.9` | `share/treeland-protocols` | `share/cmake/TreelandProtocols`, pc |
| `xdg-desktop-portal-gxde` | GXDE-OS/xdg-desktop-portal-gxde | tag `1.2.3-gxde2` | `libexec/xdg-desktop-portal-gxde`, `libxdg-desktop-portal-gxde-wayland.so*`, `share/xdg-desktop-portal*` | — |
| `all` (`default`, `gxde-infras`) | — | — | aggregate of every module's out + dev | |

## Notes
- `deepin-keyring` is the only module without upstream tags, so it is pinned to the `master` tip (`1017a81b`), using the version from GXDE's Fedora packaging (`2019.01.09`).
- `gxde-movie-reborn` is split in two derivations, because upstream builds both Qt flavours in one CMake run (`src/` and `src/libgxmr-qt6/` are Qt6, `src/libgxmr/` is Qt5) and nixpkgs does not allow Qt5 and Qt6 in a single derivation: `gxde-movie-reborn` (Qt6: the player and `libgxmr-qt6`) and `libgxmr` (Qt5), joined into the flake's `gxde-movie-reborn` attribute. The Qt5 half is configured as its own CMake project, which needs `CMAKE_INCLUDE_CURRENT_DIR` and the root `config.h` generated for it. Both halves work around `mpv.pc`'s long `Requires.private` list (CMake resolves it) with a local copy that drops that field.
- The 11 patches under `nix/patches/` are taken from GXDE's Fedora packaging; all of them were verified to still apply at the pinned tags.
- Nix-side adaptations: `disomaster-qt6` gets `GNUInstallDirs` from the Fedora patch; `udisks2-qt6`'s `udisks2-qt6.pc.in` concatenates `${prefix}` with the absolute `CMAKE_INSTALL_LIBDIR`, which nixpkgs rejects, so the template is rewritten to `@CMAKE_INSTALL_FULL_*@`; `gxde-network-utils-qt6` reads `DFRAMEWORK_PATH` from the environment, needs `translate_generation.sh` to be executable with a patched shebang, and links against `dframework-dbus-qt6`; `xdg-desktop-portal-gxde` hardcodes `/usr/share/wayland/wayland.xml`, which is replaced by the copy shipped in `wayland-scanner`; `gxde-api` builds in GOPATH mode against `golang-gxde-dev` (`GO111MODULE=off`, `GOPROXY=off`, writable `GOCACHE`) and needs nixpkgs' separate `gdk-pixbuf-xlib` for `gdk-pixbuf-xlib-2.0.pc`; `libgnome-keyring` needs `autoreconfHook` and `GPGRT_CONFIG` pointing at `libgpg-error`'s `gpgrt-config`.

## Building via Script
### Basic Instructions
```bash
$ chmod a+x ./build-nix
$ ./build-nix
```

### Usage
```
Usage: build-nix [options] [target]

Build a Nix package from the current directory.

Options:
  -L, --log       Show full build logs.
      --rebuild   Rebuild to check reproducibility.
      --cleanup   Cleanup results.
  -h, --help      Print help page.

Target:
  A .nix file or a flake installable, such as .#package.
  Defaults to the target where this script is in.
```

## Licensing
(C) 2026 CharOfString.

The packaging in this repository — the Nix expressions, `build-nix` and the documentation — is licensed under [MIT](./LICENSE).

The patches under [`nix/patches/`](./nix/patches) modify sources of the corresponding upstream projects and are provided under those projects' licenses:

| Patch | Upstream | License |
| --- | --- | --- |
| `golang-gxde-dev/0001-use-portable-alsa-header.patch` | GXDE-OS/golang-gxde-dev | GPL-3.0-or-later |
| `gxde-api/0001-fedora-package-queries.patch` | GXDE-OS/gxde-api | GPL-3.0-or-later |
| `gxde-api/0002-build-pie-executables.patch` | GXDE-OS/gxde-api | GPL-3.0-or-later |
| `gxde-api/0003-prepare-before-parallel-build.patch` | GXDE-OS/gxde-api | GPL-3.0-or-later |
| `disomaster-qt6/0001-fedora-build.patch` | GXDE-OS/disomaster-qt6 | GPL-3.0-or-later |
| `gxde-desktop-base/0001-scope-fedora-session-defaults.patch` | GXDE-OS/gxde-desktop-base | GPL-3.0-or-later |
| `dframework-dbus-qt6/0001-fedora-build.patch` | GXDE-OS/dframework-dbus-qt6 | GPL-3.0-or-later |
| `gxde-network-utils-qt6/0001-fedora-qmake-paths.patch` | GXDE-OS/gxde-network-utils-qt6 | GPL-3.0-or-later |
| `libdbusmenu-qt6/0001-fedora-build.patch` | GXDE-OS/libdbusmenu-qt6 | LGPL-2.0-or-later |
