return {
    "stevearc/conform.nvim",
    opts = {
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
    },
}
