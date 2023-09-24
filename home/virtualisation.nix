{
  xdg.configFile."containers/storage.conf".text = ''
    [storage]
    driver = "overlay"
    graphroot = "/nix/persist/jgero/containers/graph"
    runroot = "/nix/persist/jgero/containers/run"
  '';
}
