{ pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs;[
      ripgrep
      fzf
      gcc
      fd
    ];
    plugins = with pkgs.vimPlugins;
      let
        transparent = pkgs.vimUtils.buildVimPlugin {
          name = "vim-better-whitespace";
          src = pkgs.fetchFromGitHub {
            owner = "xiyaowong";
            repo = "transparent.nvim";
            rev = "f09966923f7e329ceda9d90fe0b7e8042b6bdf31";
            sha256 = "sha256-Z4Icv7c/fK55plk0y/lEsoWDhLc8VixjQyyO6WdTOVw=";
          };
        };
      in
      [
        nvim-treesitter
        nvim-lspconfig

        onedark-nvim
        transparent

        lsp_lines-nvim
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp-treesitter
        luasnip
        cmp_luasnip
        friendly-snippets

        comment-nvim
        vim-surround
        vim-repeat

        telescope-nvim
        telescope-fzf-native-nvim

        undotree
        vim-fugitive
        gitsigns-nvim
      ];
    extraLuaConfig = lib.strings.concatStringsSep "\n"
      (lib.attrsets.mapAttrsToList
        (name: value:
          if lib.strings.hasSuffix ".lua.nix" name then
            "require('jgero.${lib.strings.removeSuffix ".lua.nix" name}')"
          else if lib.strings.hasSuffix ".lua" name then
            "require('jgero.${lib.strings.removeSuffix ".lua" name}')"
          else ""
        )
        (builtins.readDir ./config)
      ++ [
      ]);
  };
  xdg.configFile = (lib.attrsets.mapAttrs'
    (name: value:
      if lib.strings.hasSuffix ".lua.nix" name then
        (lib.attrsets.nameValuePair
          ("nvim/lua/jgero/" +
            (lib.strings.removeSuffix ".nix" name))
          ({ text = import ./config/${name} { inherit pkgs lib; }; }))
      else if lib.strings.hasSuffix ".lua" name then
        (lib.attrsets.nameValuePair ("nvim/lua/jgero/" + name) ({ text = builtins.readFile ./config/${name}; }))
      else { }
    )
    (builtins.readDir ./config));
}
