return {
    {
        "mason-org/mason.nvim",
        dependencies = {
            { "mason-org/mason-lspconfig.nvim" },
            { "WhoIsSethDaniel/mason-tool-installer.nvim" },
        },
        config = function()
            require("mason").setup()

            local language_servers = {
                bashls = {
                    filetypes = { "sh", "zsh" },
                },
                lua_ls = true,
                gopls = true,
                rust_analyzer = {
                    manual_install = true,
                },
                ts_ls = true,
                tailwindcss = true,
                emmet_language_server = true,
            }

            local servers_to_install = vim.tbl_filter(function(key)
                local t = language_servers[key]
                if type(t) == "table" then
                    return not t.manual_install
                else
                    return t
                end
            end, vim.tbl_keys(language_servers))

            local other_tools = {
                formatters = {
                    "stylua",
                    "prettierd",
                    "goimports",
                },
                linters = {
                    "sonarlint-language-server",
                },
            }

            local ensure_installed = servers_to_install
            for _, group in pairs(other_tools) do
                vim.list_extend(ensure_installed, group)
            end

            require("mason-tool-installer").setup {
                ensure_installed = ensure_installed,
            }

            for name, config in pairs(language_servers) do
                if config == true then
                    config = {}
                end
                vim.lsp.config(name, config)
            end

            require("mason-lspconfig").setup {
                automatic_enable = {
                    exclude = { "jdtls" },
                },
            }
        end,
    },
}
