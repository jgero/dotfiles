{ pkgs, background, foreground, ... }: pkgs.writeText "bar.css" ''
  * {
      font-family: "JetBrains Mono";
      font-size: 14px;
  }

  window#waybar {
      background: transparent;
      border: none;
  }

  /* standalone segment */
  #battery,
  #bluetooth,
  #clock,
  #cpu,
  #custom-nixstore,
  #custom-coretemp,
  #language,
  #memory,
  #network,
  #workspaces button,
  #submap,
  #wireplumber {
      padding: 0 10px;
      margin: 6px 3px;
      border-radius: 4px;
      border: 1px solid ${background};
      font-weight: bold;
      background-color: ${background};
      color: ${foreground};
      transition: opacity .3s ease-out;
      opacity: 1;
  }
  /* inactive segment */
  #bluetooth.off,
  #network.disabled,
  #network.disconnected,
  #wireplumber.muted,
  #battery.plugged {
      opacity: 0.5;
  }
  /* left part of multi-segment */
  #custom-coretemp,
  #language,
  #network,
  #bluetooth,
  #cpu {
      margin-right: 0px;
      padding-right: 3px;
      border-top-right-radius: 0px;
      border-bottom-right-radius: 0px;
  }
  /* right part of multi-segment */
  #custom-coretemp,
  #network,
  #bluetooth,
  #wireplumber,
  #memory {
      margin-left: 0px;
      padding-left: 3px;
      border-top-left-radius: 0px;
      border-bottom-left-radius: 0px;
  }
  /* merge segments */
  #custom-coretemp {
      padding-left: 0;
  }
  #cpu {
      padding-right: 0;
  }

  #mode {
      border-color: transparent;
      background-color: transparent;
      color: ${background};
  }

  #workspaces button {
      transition: background-color .3s ease-out;
  }

  #workspaces button.focused {
      color: ${background};
      background-color: ${foreground};
  }

  #battery.warning {
      border-color: #EF6C00;
      background-color: #EF6C00;
      color: white;
  }
  #battery.critical {
      border-color: #F44336;
      background-color: #F44336;
      color: white;
  }
  #battery.charging {
      background-color: #4EFF63;
      border-color: #4EFF63;
      color: white;
  }
''
