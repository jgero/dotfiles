{
  programs.wofi = {
    enable = true;
    style = ''
      * {
          font-family: "JetBrains Mono";
          background-color: transparent;
          color: white;
      }
      window {
          background-color: black;
          border-radius: 10px;
          border: 2px solid #5074bd;
      }
      #entry:selected {
          background-color: #5074bd;
          color: white;
      }
    '';
  };
}
