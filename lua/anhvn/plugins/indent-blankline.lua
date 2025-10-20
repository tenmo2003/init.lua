return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = function()
            vim.api.nvim_set_hl(0, "AnhVNIndentScope", { fg = "#7d87a8" })

            return {
                scope = {
                    highlight = "AnhVNIndentScope",
                    show_start = false,
                    show_end = false,
                },
            }
        end,
    },
}
