{ osConfig, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Johannes Gerold";
        email = osConfig.jgero.user.email;
      };
      init = { defaultBranch = "main"; };
    };
  };
}
