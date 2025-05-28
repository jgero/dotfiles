pkgs: (pkgs.stdenv.mkDerivation {
  de_spell = builtins.fetchurl {
    url = "https://ftp.nluug.nl/vim/runtime/spell/de.utf-8.spl";
    sha256 = "1ld3hgv1kpdrl4fjc1wwxgk4v74k8lmbkpi1x7dnr19rldz11ivk";
  };
  de_suggestions = builtins.fetchurl {
    url = "https://ftp.nluug.nl/vim/runtime/spell/de.utf-8.sug";
    sha256 = "0j592ibsias7prm1r3dsz7la04ss5bmsba6l1kv9xn3353wyrl0k";
  };
  en_spell = builtins.fetchurl {
    url = "https://ftp.nluug.nl/vim/runtime/spell/en.utf-8.spl";
    sha256 = "0w1h9lw2c52is553r8yh5qzyc9dbbraa57w9q0r9v8xn974vvjpy";
  };
  en_suggestions = builtins.fetchurl {
    url = "https://ftp.nluug.nl/vim/runtime/spell/en.utf-8.sug";
    sha256 = "1v1jr4rsjaxaq8bmvi92c93p4b14x2y1z95zl7bjybaqcmhmwvjv";
  };
  name = "nvim-spell-files";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/spell
    cp $de_spell $out/spell/de.utf-8.spl
    cp $de_suggestions $out/spell/de.utf-8.sug
    cp $en_spell $out/spell/en.utf-8.spl
    cp $en_suggestions $out/spell/en.utf-8.sug
  '';
})
