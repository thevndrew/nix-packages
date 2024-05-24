{
  writeShellApplication,
  pkgs,
  ...
}: let
  name = "patreon-dl-fmt";
in
  writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [detox pandoc];
    text = builtins.readFile ./patreon-dl-fmt.bash;
  }
