{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    bootdev = {
      url = "github:bootdotdev/bootdev";
      flake = false;
    };
  };

  outputs = inputs @ {flake-parts, ...}
  :
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        pkgs-list = with self'.packages; [
          bootdev
          chrome-wrapper
          crx-dl
          megadl
        ];
      in {
        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs =
              (with pkgs; [
                just
              ])
              ++ pkgs-list;
          };
        };

        formatter = pkgs.alejandra;

        packages = {
          bootdev = pkgs.callPackage ./pkgs/bootdev {inherit inputs;};
          chrome-wrapper = pkgs.callPackage ./pkgs/chrome-wrapper {inherit inputs;};
          cockpit-podman = pkgs.callPackage ./pkgs/cockpit-podman {inherit inputs;};
          crx-dl = pkgs.callPackage ./pkgs/crx-dl {inherit inputs;};
          megadl = pkgs.callPackage ./pkgs/megadl {inherit inputs;};
        };
      };
    };
}
