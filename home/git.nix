{ osConfig, ... }: {
  programs.git = {
    enable = true;
    userName = "Johannes Gerold";
    userEmail = osConfig.jgero.user.email;
    extraConfig = {
      init = { defaultBranch = "main"; };
    };
  };
}
