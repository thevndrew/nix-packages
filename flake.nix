{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    bootdev = {
      url = "github:bootdotdev/bootdev";
      flake = false;
    };

    nvim-dbee = {
      url = "github:kndndrj/nvim-dbee";
      flake = false;
    };

    yt-dlp-youtube-oauth2 = {
      url = "github:coletdjnz/yt-dlp-youtube-oauth2";
      flake = false;
    };

    yt-dlp-get-pot = {
      url = "github:coletdjnz/yt-dlp-get-pot";
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
          # chrome-wrapper
          crx-dl
          megadl
          yt-dlp-get-pot
          yt-dlp-youtube-oauth2
          nvim-debee
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
          yt-dlp-get-pot = pkgs.callPackage ./pkgs/yt-dlp-get-pot {inherit inputs;};
          yt-dlp-youtube-oauth2 = pkgs.callPackage ./pkgs/yt-dlp-youtube-oauth2 {inherit inputs;};
          nvim-debee = pkgs.callPackage ./pkgs/nvim-debee {inherit inputs;};
        };
      };
    };
}
