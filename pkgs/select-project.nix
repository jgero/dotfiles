{ pkgs }: pkgs.writeScriptBin "select-project" ''
  if [[ "$#" -eq 1 ]]; then
      # if an argument was given use this as selection target
      selected="$1"
  else
      # get a project from the pre-specified directories
      selected=$(find \
          $HOME/projects \
          -mindepth 1 -maxdepth 1 -type d | fzf)
  fi

  # exit if no project was selected
  if [[ -z "$selected" ]]; then
      exit 0
  fi

  selected_name=$(basename "$selected" | tr . _)
  tmux_running=$(pgrep tmux)

  # if tmux is inactive create and attach
  if [[ -z "$TMUX" ]] && [[ -z "$tmux_running" ]]; then
      tmux new-session -s "$selected_name" -c "$selected"
      exit 0
  fi

  # create session if it does not already exist
  if ! tmux has-session -t="$selected_name" 2> /dev/null; then
      tmux new-session -ds "$selected_name" -c "$selected"
  fi

  if [[ -z "$TMUX" ]]; then
      tmux attach-session -t "$selected_name"
  else
      tmux switch-client -t "$selected_name"
  fi
''
