{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      gcc
      rnix-lsp
      sumneko-lua-language-server
      jdt-language-server
      rust-analyzer
      go
      gopls
    ];

    extraConfig = ''
lua << EOF
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

-- clone packer if it is missing
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end

${builtins.readFile ./general.lua}
utils.opt('o', 'backupdir', '${config.xdg.dataHome}/nvim/backup')

require('packer').startup(function(use)
  use('wbthomason/packer.nvim')
  use('tpope/vim-surround')
  use('tpope/vim-repeat')

  -- navigation
  use({
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function() ${builtins.readFile ./telescope.lua} end
  })
  use({
    'ThePrimeagen/harpoon',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('harpoon').setup()
    end,
  })

  -- visuals
  use({
    'folke/tokyonight.nvim',
    config = function()
        vim.cmd([[colorscheme tokyonight-night]])
    end
  })

  -- git stuff
  use('tpope/vim-fugitive')
  use({
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() ${builtins.readFile ./gitsigns.lua} end,
  })

  -- syntax / langauge
  use({
    'nvim-treesitter/nvim-treesitter',
    config = function() ${builtins.readFile ./treesitter.lua} end,
    run = ':TSUpdate'
  })
  use({
    'numToStr/Comment.nvim',
    config = function() ${builtins.readFile ./context-comments.lua} end,
  })
  use({
    'JoosepAlviste/nvim-ts-context-commentstring',
    requires = { 'nvim-treesitter/nvim-treesitter', 'numToStr/Comment.nvim' },
  })
  use({
    'hrsh7th/nvim-cmp',
    config = function() ${builtins.readFile ./lsp-completion.lua} end,
    requires = {
      --completion sources
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'ray-x/cmp-treesitter',
      -- snippets
        'l3mon4d3/luasnip',
        'saadparwaiz1/cmp_luasnip',
    },
  })
  use({ 'ray-x/cmp-treesitter', requires = { 'nvim-treesitter/nvim-treesitter' }})
  use({'saadparwaiz1/cmp_luasnip', requires = { 'l3mon4d3/luasnip'}})

  use({
      'neovim/nvim-lspconfig',
    config = function()
      local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local jdtls_workspace = "${config.xdg.dataHome}/jdtls/" .. project_dir
    ${builtins.readFile ./lsp-server-commons.lua}
        require('lspconfig').gopls.setup {
          cmd = { "${pkgs.gopls}/bin/gopls" },
          capabilities = capabilities,
          on_attach = on_attach,
        }
        require('lspconfig').rnix.setup {
          cmd = { "${pkgs.rnix-lsp}/bin/rnix-lsp" },
          capabilities = capabilities,
          on_attach = on_attach,
        }
        require('lspconfig').rust_analyzer.setup {
          cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
          capabilities = capabilities,
          on_attach = on_attach,
        }
        require('lspconfig').jdtls.setup {
            cmd = { "${pkgs.jdt-language-server}/bin/jdt-language-server", "-data", jdtls_workspace },
            capabilities = capabilities,
            on_attach = on_attach,
        }
        require('lspconfig').sumneko_lua.setup {
          cmd = { "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" },
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
              },
            },
            runtime = {
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
            },
            workspace = {
              library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
              },
            },
          },
        }
      
    end
  })
    use({
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
          require("lsp_lines").setup()
          vim.diagnostic.config({ virtual_text = false })
      end,
    })
end)
EOF
    '';
  };
}
