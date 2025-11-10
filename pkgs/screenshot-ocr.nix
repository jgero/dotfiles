{ pkgs }: pkgs.writeScriptBin "screenshot-ocr" ''
  tmpfile_png=$(mktemp /tmp/screenshot-ocr.XXXXXXXXX --suffix .png)
  ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" $tmpfile_png
  text="$(${pkgs.tesseract}/bin/tesseract $tmpfile_png - -l eng)"
  echo $text | ${pkgs.wl-clipboard}/bin/wl-copy
  rm $tmpfile_png
''
