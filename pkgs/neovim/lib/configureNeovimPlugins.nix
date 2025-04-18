{ pkgs }:

plugins:

let
  # Default order if not specified
  addDefaultOrder = p: p // { order = p.order or 1000; };

  sortedPlugins = builtins.sort
    (
      a: b: a.order < b.order
    )
    (map addDefaultOrder plugins);

  runtimeDeps = builtins.concatLists (map (p: p.dependencies or [ ]) sortedPlugins);

  runtimePath = pkgs.symlinkJoin {
    name = "nvim-plugins-runtime";
    paths = runtimeDeps;
  };

  neovimPlugins = builtins.concatLists (map (p: p.plugins or [ ]) sortedPlugins);

  init-lua = pkgs.writeText "init.lua" (builtins.concatStringsSep "\n" (
    map
      (p: ''-- ${p.name}
${p.config or ""}
'')
      sortedPlugins
  ));

in
{
  inherit neovimPlugins runtimePath init-lua;
}
