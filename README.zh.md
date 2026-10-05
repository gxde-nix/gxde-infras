# GXDE Infras
GXDE 桌面环境的基础设施包：Go 源码集、服务运行器、Qt6 库、桌面元数据、schema、协议描述以及 XDG 桌面门户。

## 版本
| flake attr | 上游 | pin | out 内容 | dev 内容 |
| --- | --- | --- | --- | --- |
| `golang-gxde-dev` | GXDE-OS/golang-gxde-dev | tag `1.0.6` | `share/gocode-gxde/src` | — |
| `gxde-k9` | GXDE-OS/gxde-k9 | tag `2.0.0` | `bin/gxde-k9{,-chocker}`、`share/gxde-k9`、`etc/xdg/autostart` | — |
| `gxde-api` | GXDE-OS/gxde-api | tag `4.0.6` | `bin/dde-open`、`lib/deepin-api`、`share/dbus-1`、`share/polkit-1`、`share/gxde-api`、`var/lib/polkit-1` | — |
| `disomaster-qt6` | GXDE-OS/disomaster-qt6 | tag `1.0.0-gxde2` | `libdisomaster6.so.1*` | `include/disomaster-qt6`、`disomaster-qt6.pc` |
| `deepin-keyring` | GXDE-OS/deepin-keyring | `master`（无 tag） | `share/keyrings/*.gpg` | — |
| `libgnome-keyring` | GXDE-OS/libgnome-keyring | tag `3.12.0-3` | `libgnome-keyring.so.3*`、typelib | `include/gnome-keyring-1`、`gnome-keyring-1.pc`、gir、vapi |
| `gxde-desktop-base` | GXDE-OS/gxde-desktop-base | tag `2026.10.04` | `lib/deepin`、`share/deepin`、`share/i18n`、`etc/profile.d`、`etc/xdg/autostart` | — |
| `gxde-desktop-schemas` | GXDE-OS/gxde-desktop-schemas | tag `4.0.7` | `share/glib-2.0/schemas`、`share/deepin-appstore` | — |
| `dframework-dbus-qt6` | GXDE-OS/dframework-dbus-qt6 | tag `6.0.1-gxde3` | `libdframeworkdbus-qt6.so.6*` | `include/libdframeworkdbus-qt6-6.0`、cmake |
| `gxde-network-utils-qt6` | GXDE-OS/gxde-network-utils-qt6 | tag `6.0.1` | `libgxde-network-utils-qt6.so.*`、翻译 | `include/libgxde-network-utils-qt6`、pc |
| `udisks2-qt6` | GXDE-OS/udisks2-qt6 | tag `6.0.1` | `libudisks2-qt6.so.*` | `include/udisks2-qt6`、pc、cmake |
| `libdbusmenu-qt6` | GXDE-OS/libdbusmenu-qt6 | tag `0.9.3+16.04.20160218-6` | `libdbusmenu-qt6.so.*` | `include/dbusmenu-qt6`、pc、cmake |
| `wlr-protocols` | GXDE-OS/wlr-protocols | tag `0.0+git20231016-0deepin` | `share/wlr-protocols`、`share/pkgconfig` | — |
| `treeland-protocols` | GXDE-OS/treeland-protocols | tag `0.5.9` | `share/treeland-protocols` | `share/cmake/TreelandProtocols`、pc |
| `xdg-desktop-portal-gxde` | GXDE-OS/xdg-desktop-portal-gxde | tag `1.2.3-gxde2` | `libexec/xdg-desktop-portal-gxde`、`libxdg-desktop-portal-gxde-wayland.so*`、`share/xdg-desktop-portal*` | — |
| `all`（`default`、`gxde-infras`） | — | — | 所有模块 out+dev 的汇总 | |

## 说明
- `deepin-keyring` 上游没有任何 tag，因此 pin 到 `master` 顶端（`1017a81b`），版本号沿用 GXDE Fedora 打包里的 `2019.01.09`。
- `gxde-movie-reborn` 拆成了两个 derivation：上游在一次 CMake 里同时编两种 Qt（`src/` 与 `src/libgxmr-qt6/` 是 Qt6，`src/libgxmr/` 是 Qt5），而 nixpkgs 不允许单个 derivation 混用 Qt5/Qt6。于是有 `gxde-movie-reborn`（Qt6：播放器 + `libgxmr-qt6`）与 `libgxmr`（Qt5），再由 flake 的 `gxde-movie-reborn` 属性合并。Qt5 那半是作为独立 CMake 工程配置的，需要额外打开 `CMAKE_INCLUDE_CURRENT_DIR` 并为其生成根目录的 `config.h`。两半都用一份去掉 `Requires.private` 的本地 `mpv.pc` 绕过 CMake 对 mpv 那一长串私有依赖的解析。
- `nix/patches/` 下的 11 个补丁取自 GXDE 的 Fedora 打包，并且都在 pin 的 tag 上验证过仍可应用。
- Nix 侧的适配：`disomaster-qt6` 依赖 Fedora 补丁带来的 `GNUInstallDirs`；`udisks2-qt6` 的 `udisks2-qt6.pc.in` 把 `${prefix}` 和绝对的 `CMAKE_INSTALL_LIBDIR` 拼在一起（nixpkgs 会拒绝），因此模板改写成 `@CMAKE_INSTALL_FULL_*@`；`gxde-network-utils-qt6` 从**环境变量**读 `DFRAMEWORK_PATH`，`translate_generation.sh` 需要可执行位 + 改写 shebang，并链接 `dframework-dbus-qt6`；`xdg-desktop-portal-gxde` 里写死的 `/usr/share/wayland/wayland.xml` 换成 `wayland-scanner` 里那份；`gxde-api` 以 GOPATH 模式对 `golang-gxde-dev` 构建（`GO111MODULE=off`、`GOPROXY=off`、可写 `GOCACHE`），并且需要 nixpkgs 单独的 `gdk-pixbuf-xlib`（提供 `gdk-pixbuf-xlib-2.0.pc`）；`libgnome-keyring` 需要 `autoreconfHook` 以及指向 `libgpg-error` 的 `gpgrt-config` 的 `GPGRT_CONFIG`。

## 使用脚本构建
### 基本使用
```bash
$ chmod a+x ./build-nix
$ ./build-nix
```

### 使用说明
```
用法: build-nix [选项] [目标]

从本地目录构建Nix包。

选项:
  -L, --log       构建时打印日志
      --rebuild   重新构建以检查可复现性
      --cleanup   清理产物
  -h, --help      打印帮助

目标:
  一个.nix文件或者flake installable，例如.#package。
  默认在当前目录查找。
```

## 许可证
(C) 2026 CharOfString.

本仓库的打包部分（Nix 表达式、`build-nix`、文档）以 [MIT](./LICENSE) 协议授权。

[`nix/patches/`](./nix/patches) 下的补丁修改的是对应上游项目的源码，按**原仓库协议**提供：

| 补丁 | 上游 | 协议 |
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
