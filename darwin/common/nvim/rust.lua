-- Rust specific setup
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
