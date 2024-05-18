{
  lib,
  system,
  python3Packages,
  pkgs,
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
  name = "megadl";
  version = "0.0.1";
in
  with python3Packages;
    buildPythonApplication {
      inherit name version;
      propagatedBuildInputs = with pkgs; [megatools python3Packages.requests];
      src = ./.;
    }
