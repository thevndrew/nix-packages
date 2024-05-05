{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    bootdev = {
      url = "github:bootdotdev/bootdev";
      flake = false;
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        devShells = {
          default = pkgs.mkShell {
            inputsFrom = [ self'.packages.bootdev self'.packages.megadl ];
            nativeBuildInputs = [ pkgs.just self'.packages.bootdev self'.packages.megadl ];
          };
        };

        formatter = pkgs.alejandra;

        packages = {
          bootdev = pkgs.callPackage ./pkgs/bootdev { inherit inputs; };
          megadl = pkgs.callPackage ./pkgs/megadl { inherit inputs; };
        };
      };
    };
}
