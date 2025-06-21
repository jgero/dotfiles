{ pkgs, ... }: {
  programs.tmux =
    let
      background = "#23323f";
      foreground = "#969591";
    in
    {
      enable = true;
      clock24 = true;
      escapeTime = 0;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig =
        let
          pid-mem = pkgs.writeScriptBin "pid-mem" ''
            ps -p $1 -o %mem | tr -dc "[:digit:]."
          '';
          pid-cpu = pkgs.writeScriptBin "pid-cpu" ''
            ps -p $1 -o %cpu | tr -dc "[:digit:]."
          '';
          git-branch = pkgs.writeScriptBin "git-branch" ''
            git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
          '';
        in
        ''
          set -s copy-command 'wl-copy'

          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'

          # vim-like pane resizing  
          bind -r K resize-pane -U
          bind -r J resize-pane -D
          bind -r H resize-pane -L
          bind -r L resize-pane -R

          # vim-like pane switching
          bind -r k select-pane -U 
          bind -r j select-pane -D 
          bind -r h select-pane -L 
          bind -r l select-pane -R 

          # splits
          bind Enter split-window -h
          # first I wanted this to be C-Enter but for some reason I can't get this to work
          bind Space split-window

          # start cheat.sh wrapper
          bind-key -r i run-shell "tmux neww cheat"

          # kill panes
          bind -r q kill-pane

          # and now unbind keys
          unbind Up     
          unbind Down   
          unbind Left   
          unbind Right  
          unbind C-Up   
          unbind C-Down 
          unbind C-Left 
          unbind C-Right

          set-option -g status-style bg=${background}
          set -g status-left-length 30
          set -g status-left "#[fg=${foreground},bg=${background},bold] #(echo $(${git-branch}/bin/git-branch))@#S #[bg=default] "
          set -g window-status-current-format "#[fg=${background},bg=${foreground},bold] #I: #W "
          set -g window-status-format "#[fg=${foreground},bg=${background}]#{?window_last_flag,#[bold],} #I: #W "
          set -g status-right "#[fg=${foreground},bg=${background},bold] [#{pid}] CPU: #(echo $(${pid-cpu}/bin/pid-cpu #{pid}))% MEM: #(echo $(${pid-mem}/bin/pid-mem #{pid}))% "
        '';
    };
}
