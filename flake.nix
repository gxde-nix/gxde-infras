{
  description = "Nix packaging of GXDE infrastructure (Go sources, service runner, Qt6 libraries, schemas, portal)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gxde-dtk5 = {
      url = "github:gxde-nix/gxde-dtk5";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gxde-dtk6 = {
      url = "github:gxde-nix/gxde-dtk6";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gxde-dtk2 = {
      url = "github:gxde-nix/gxde-dtk2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, gxde-dtk5, gxde-dtk6, gxde-dtk2 }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "riscv64-linux" ];

      mkPackages = system: pkgs: import ./default.nix {
        inherit pkgs;
        dtk5 = gxde-dtk5.packages.${system};
        dtk6 = gxde-dtk6.packages.${system};
        dtk2 = gxde-dtk2.packages.${system};
      };
    in
    {
      overlays.default = final: prev: {
        gxdeInfras = mkPackages final.stdenv.hostPlatform.system final;
      };
    }
    // flake-utils.lib.eachSystem systems
      (system:
        let
          packages = mkPackages system nixpkgs.legacyPackages.${system};
        in
        {
          inherit packages;
          checks.infras = packages.all;
        });
}
