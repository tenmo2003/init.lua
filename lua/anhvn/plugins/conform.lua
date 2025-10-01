return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require "conform"

        conform.setup {
            format_on_save = function(bufnr)
                local ignore_filetypes = { "java" }
                if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                    return nil
                end
                return {
                    timeout_ms = 500,
                }
            end,
            formatters = {
                prettierjava = {
                    command = "prettierd",
                    args = { "$FILENAME" },
                },
            },
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofmt", "goimports" },
                javascript = { "prettierd" },
                javascriptreact = { "prettierd" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
                java = { "prettierjava" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
        }

        vim.keymap.set("n", "<leader>fc", function()
            conform.format { bufnr = 0 }
            print "Formatted"
        end, { desc = "Format with conform" })
    end,
}
