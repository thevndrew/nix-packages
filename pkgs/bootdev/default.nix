{
  lib,
  inputs,
  system,
  buildGoModule,
  ...
}: let
  filterSystem = s:
    {
      "x86_64-linux" = {
        sha256 = "${lib.fakeHash}";
        system = "linux_amd64";
      };
    }
    .${s}
    or (throw "Unsupported system: ${s}");
  metadata = filterSystem system;
  name = "bootdev";
  version = "v0.0.1";
in
  buildGoModule rec {
    inherit name version;
    src = inputs.bootdev;
    # vendorHash = "${lib.fakeHash}"; # also lib.fakeSHA256
    vendorHash = "sha256-v5P+Pt9weZ6+kkxfgpk+8GIOJRqp+Jx5uF3AJdRnp0s=";
  }
