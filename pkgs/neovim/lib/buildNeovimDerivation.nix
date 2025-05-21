{ pkgs }: pluginDefs:
let
  configurePlugins = import ./configureNeovimPlugins.nix { inherit pkgs; };
  pluginSetup = configurePlugins pluginDefs;
  configuredNeovim = pkgs.neovim.override {
    configure = {
      packages.myNeovimPackage = {
        start = pluginSetup.startPlugins or [];
        opt = pluginSetup.optPlugins or [];
      };
    };
  };
in
pkgs.symlinkJoin {
  name = "my-neovim";
  paths = [ configuredNeovim ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --add-flags '-u' \
      --add-flags '${pluginSetup.init-lua}' \
      --add-flags '--cmd' \
      --add-flags "'set runtimepath^=${pluginSetup.runtimePath}'"
  '';
}
