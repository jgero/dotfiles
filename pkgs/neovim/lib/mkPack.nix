pkgs: def:
let
  init = pkgs.writeText "${def.name}-init.lua" def.init;
in
pkgs.stdenv.mkDerivation (rec {
  inherit init;
  pname = def.name;
  plugins = def.plugins or [ ];
  dependencies = def.dependencies or [ ];
  order = def.order or 1000;
  version = "1";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/lua/${pname}
    cp $init $out/lua/${pname}/init.lua
    ${if (def ? sources) then "cp $src/* $out/lua/${pname}/" else ""}
  '';
} // (if (def ? sources) then { src = def.sources; } else { }))
