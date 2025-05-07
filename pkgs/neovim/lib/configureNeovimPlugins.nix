{ pkgs }:

plugins:

let
  # sort plugins
  sortedPlugins = builtins.sort
    (
      a: b: a.order < b.order
    )
    plugins;

  # concat all dependencies into one flat runtime dependency list
  runtimeDeps = builtins.concatLists (map (p: p.dependencies or [ ]) sortedPlugins);
  # build one derivation that contains all runtime deps
  runtimePath = pkgs.symlinkJoin {
    name = "nvim-plugins-runtime";
    paths = runtimeDeps;
  };

  # collect all neovim plugin dependencies
  neovimPlugins = (builtins.concatLists (map (p: p.plugins or [ ]) sortedPlugins)) ++
    # and add the plugins themselves to the list
    sortedPlugins;

  init-lua = pkgs.writeText "init.lua" (builtins.concatStringsSep "\n" (
    map
      (p: ''require("${p.pname}")
'')
      (builtins.filter (p: p.init != "") sortedPlugins)
  ));

in
{
  inherit neovimPlugins runtimePath init-lua;
}
