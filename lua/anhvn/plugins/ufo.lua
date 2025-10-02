return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        config = function()
            -- vim.o.foldcolumn = "1" -- '0' is not bad
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- ###################### USE LSP FOLDING ######################
            -- local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities.textDocument.foldingRange = {
            --     dynamicRegistration = false,
            --     lineFoldingOnly = true,
            -- }
            -- local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
            -- for _, ls in ipairs(language_servers) do
            --     vim.lsp.config(ls, {
            --         capabilities = capabilities,
            --     })
            -- end
            -- require("ufo").setup()

            -- ###################### USE TREESITTER FOLDING ######################
            require("ufo").setup {
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end,
            }
        end,
    },
}
