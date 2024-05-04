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
            inputsFrom = [ self'.packages.bootdev ];
            nativeBuildInputs = [ pkgs.just self'.packages.bootdev ];
          };
        };

        formatter = pkgs.alejandra;

        packages = {
          bootdev = pkgs.callPackage ./pkgs/bootdev { inherit inputs; };
        };
      };
    };
}
