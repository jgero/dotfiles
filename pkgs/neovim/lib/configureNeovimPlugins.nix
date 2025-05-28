{ pkgs }:

let
  sortPartials = filter: partials: builtins.sort (a: b: a.order < b.order) (filter partials);
  onlyStartPartials = partials: builtins.filter (p: !p.opt) partials;
  onlyOptPartials = partials: builtins.filter (p: p.opt) partials;

  # extract the binaries the plugins require to be present
  extractRuntimeDeps = partials: builtins.concatLists (map (p: p.dependencies or [ ]) partials);

  withDependencies = partials: (builtins.concatLists (map (p: p.plugins or [ ]) partials)) ++ partials;
  onlyPartialsWithInit = partials: builtins.filter (p: p.init != "") partials;
  generateInitLua = filter: partials: pkgs.writeText "init.lua" (builtins.concatStringsSep "\n" (map (p: ''require("${p.pname}")'') (filter partials)));
in

allPartials:

let
  # separate and sort partials
  startPartials = sortPartials onlyStartPartials allPartials;
  optPartials = sortPartials onlyOptPartials allPartials;

  # concat all dependencies into one flat runtime dependency list
  runtimeDeps = extractRuntimeDeps allPartials;
  # build one derivation that contains all runtime deps
  runtimePath = pkgs.symlinkJoin {
    name = "nvim-plugins-runtime";
    paths = runtimeDeps;
  };
  # generate a init.lua file that references all partials
  init-lua = generateInitLua onlyPartialsWithInit startPartials;
  # collect all plugins and their dependencies
  startPlugins = withDependencies startPartials;
  # TODO: plugin dependencies of optional plugins also need to be "packadd"ed
  optPlugins = withDependencies optPartials;
in
{
  inherit startPlugins optPlugins runtimePath init-lua;
}
