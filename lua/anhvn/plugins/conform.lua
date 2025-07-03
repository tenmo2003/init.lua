return {
	"stevearc/conform.nvim",
	opts = {
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "gofmt" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
		},
	},
}
