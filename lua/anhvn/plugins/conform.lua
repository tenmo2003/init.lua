return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require "conform"

        conform.setup {
            format_on_save = {
                timeout_ms = 500,
            },
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofmt", "goimports" },
                javascript = { "prettierd" },
                javascriptreact = { "prettierd" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
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
