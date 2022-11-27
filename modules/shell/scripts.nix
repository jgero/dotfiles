{ pkgs, ... }:
let
  selectProject = pkgs.writeScriptBin "selectProject" (builtins.readFile ./scripts/selectProject.zsh);
  quicknote = pkgs.writeScriptBin "quicknote" (builtins.readFile ./scripts/quicknote.zsh);
in
{
  home.packages = with pkgs; [
    selectProject
    quicknote
  ];
}
