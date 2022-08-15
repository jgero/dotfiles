{ pkgs, ... }:
let
  selectProject = pkgs.writeScriptBin "selectProject" (builtins.readFile ./scripts/selectProject.zsh);
in
{
  home.packages = with pkgs; [
    selectProject
  ];
}
