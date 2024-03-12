{ pkgs, nixpkgs, ... }:
let
  nixpkgs-doc = pkgs.stdenv.mkDerivation {
    name = "nixpkgs-doc";
    src = nixpkgs;
    buildInputs = [
      pkgs.w3m
    ];
    buildPhase = ''
      mkdir -p $out/nixpkgs
      w3m -dump ${nixpkgs.htmlDocs.nixpkgsManual}/share/doc/nixpkgs/manual.html > $out/nixpkgs/index.txt
      mkdir -p $out/nixos
      cd ${nixpkgs.htmlDocs.nixosManual}/share/doc/nixos
      find -name \*.html | cut -c 3- | sed 's/\.html//' | xargs -I file sh -c "w3m -dump ./file.html > $out/nixos/file.txt"
    '';
  };
in
''
  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>fp", function()
  	builtin.live_grep({ cwd = "${nixpkgs-doc}" })
  end, { desc = "[f]ind nix[p]kgs" })
''
