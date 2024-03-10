{ pkgs }: pkgs.writeShellApplication {
  name = "quicknote";
  text = ''
    NOTE_DIR="$HOME/data/notes/quick"
    NOTE_FILE_NAME="$NOTE_DIR/note-$(date +%Y-%m-%d).md"
    mkdir -p "$NOTE_DIR"
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
