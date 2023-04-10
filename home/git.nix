{
  programs.git = {
    enable = true;
    userName = "Johannes Gerold";
    userEmail = "git+commit@jgero.me";
    extraConfig = {
      init = { defaultBranch = "main"; };
    };
  };
}
