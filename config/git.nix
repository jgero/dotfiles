{
  programs.git = {
    enable = true;
    userName = "Johannes Gerold";
    userEmail = "mail@jgero.me";
    extraConfig = {
      init = { defaultBranch = "main"; };
    };
  };
}
