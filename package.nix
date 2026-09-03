{
  writeShellScriptBin,
  fetchurl,
  dotnet-sdk_8,
}:
let
  version = "v2026.07.3.0";
  src = fetchurl {
    url = "https://github.com/tModLoader/tModLoader/releases/download/${version}/tModLoader.zip";
    sha256 = "";
  };
in
writeShellScriptBin "tmodloader-server" ''
  #!/bin/sh
  cd ${src}
  exec ${dotnet-sdk_8}/bin/dotnet tModLoader.dll -server "$@"
''
