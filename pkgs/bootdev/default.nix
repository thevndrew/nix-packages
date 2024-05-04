{
  lib,
  inputs,
  stdenv,
  system,
  pkgs,
  ...
}: let
  filterSystem = s:
    {
      "x86_64-linux" = {
        extension = "tar.gz";
        sha256 = "sha256-tXnTnwf7OS5f6tFRZEl8UwxjuSmCj5EJwdGtxN4xbZk=";
        system = "linux_amd64";
      };
    }
    .${s}
    or (throw "Unsupported system: ${s}");
  metadata = {
    system = "linux_amd64"; 
  };
  name = "bootdev";
  version = "v0.0.1";
in
  pkgs.buildGoModule {
    inherit name version;
    src = inputs.bootdev;
    # vendorHash = "${lib.fakeHash}"; # also lib.fakeSHA256
    vendorHash = "sha256-v5P+Pt9weZ6+kkxfgpk+8GIOJRqp+Jx5uF3AJdRnp0s=";
  }
