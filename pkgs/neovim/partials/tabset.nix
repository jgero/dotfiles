{ pkgs }: {
  name = "tabset";
  plugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "tabset-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "FotiadisM";
        repo = "tabset.nvim";
        rev = "996f95e4105d053a163437e19a40bd2ea10abeb2";
        sha256 = "sha256-kOLN74p5AvZlmZRd2hT5c1uV7qziVcyIB8fpC1RiDPk=";
      };
    })
  ];
  config = ''
    require("tabset").setup({
    	defaults = {
    		tabwidth = 4,
    		expandtab = true,
    	},
    	languages = {
    		{
    			filetypes = { "go", "lua" },
    			config = {
    				tabwidth = 4,
    				expandtab = false,
    			},
    		},
    		{
    			filetypes = { "nix", "kotlin", "json", "yaml" },
    			config = {
    				tabwidth = 2,
    				expandtab = true,
    			},
    		},
    	},
    })
  '';
}
