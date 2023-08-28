{ pkgs }: pkgs.writeShellApplication {
  name = "quicknote";
  text = ''
    NOTE_FILE_NAME="$HOME/sync/notes/quick/note-$(date +%Y-%m-%d).md"
    if [ ! -f "$NOTE_FILE_NAME" ]; then
      echo "# Notes for $(date +%Y-%m-%d)" > "$NOTE_FILE_NAME"
    fi
    nvim -c "norm Go" \
      -c "norm Go## $(date +%H:%M)" \
      -c "norm G2o" \
      -c "norm zz" \
      -c "startinsert" "$NOTE_FILE_NAME"
  '';
}
