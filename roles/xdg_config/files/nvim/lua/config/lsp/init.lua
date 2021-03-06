-- lspconfig setup
-- these are the defaults so this should be first in the config
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=#3c3836
        hi LspReferenceText cterm=bold ctermbg=red guibg=#3c3836
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=#3c3836
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

-- configure servers installed by auto install plugin
require'lspinstall'.setup() -- important
local servers_to_install = require'lspinstall'.installed_servers()
local lspconfig = require'lspconfig'

for _, server in pairs(servers_to_install) do
  lspconfig[server].setup{
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern(".git", vim.fn.getcwd())
  }
end

-- extra setup for lsp containers
lspconfig.svelte.setup {
    before_init = function(params)
        params.processId = vim.NIL
    end,
    cmd = require'lspcontainers'.command('svelte', {
        additional_languages = {
            svelte = "sveltels:latest"
        },
        cmd_builder = function(volume, image)
            return {
                "podman",
                "container",
                "run",
                "--interactive",
                "--rm",
                "--volume",
                volume,
                image
            }
        end
    }),
    root_dir = lspconfig.util.root_pattern(".git", vim.fn.getcwd()),
}

require'lspconfig'.sumneko_lua.setup {
    cmd = require'lspcontainers'.command('sumneko_lua', {
        cmd_builder = function(volume, image)
            return {
                "podman",
                "container",
                "run",
                "--interactive",
                "--rm",
                "--volume",
                volume,
                image
            }
        end
    }),
    root_dir = lspconfig.util.root_pattern(".git", vim.fn.getcwd()),
}

-- apply completion settings
require('config.lsp.compe')

