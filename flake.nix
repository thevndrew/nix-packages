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
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

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
            inputsFrom = with self'.packages; [
              bootdev
              megadl
              patreon-dl-fmt
            ];
            nativeBuildInputs =
              (with pkgs; [
                just
              ])
              ++ (with self'.packages; [
                bootdev
                megadl
                patreon-dl-fmt
              ]);
          };
        };

        formatter = pkgs.alejandra;

        packages = {
          bootdev = pkgs.callPackage ./pkgs/bootdev {inherit inputs;};
          megadl = pkgs.callPackage ./pkgs/megadl {inherit inputs;};
          patreon-dl-fmt = pkgs.callPackage ./pkgs/patreon-dl-fmt {inherit inputs;};
        };
      };
    };
}
