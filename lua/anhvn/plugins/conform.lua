return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    keys = {
        {
            "<leader>fc",
            function()
                if require("conform").format() then
                    vim.notify "Formatted"
                end
            end,
            mode = "",
            desc = "Format with conform",
        },
    },
    opts = {
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
            prettierdjava = {
                command = "prettierd",
                args = { "$FILENAME" },
            },
            prettierjava = {
                command = "prettier",
                args = { "--stdin-filepath", "$FILENAME" },
                range_args = function(self, ctx)
                    return { "--range-start", ctx.range["start"], "--range-end", ctx.range["end"] }
                end,
            },
        },
        formatters_by_ft = {
            lua = { "stylua" },
            go = { "gofmt", "goimports" },
            javascript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            java = { "prettierdjava" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
    },
}
