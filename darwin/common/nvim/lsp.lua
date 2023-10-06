local lsp = require('lsp-zero').preset({})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--  capabilities = capabilities
-- }
-- Rust specific setup
local rust_tools = require('rust-tools')
rust_tools.setup {
    server = {
        settings = {
            ['rust-analyzer'] = {
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                diagnostics = {
                    enable = false,
                },
                files = {
                    excludeDirs = { ".direnv", ".git" },
                    watcherExclude = { ".direnv", ".git" },
                },
            },
        },
        on_attach = on_attach,
    },
}
