return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = function()
            local hooks = require "ibl.hooks"
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "AnhVNIndentScope", { fg = "#7d87a8" })
            end)

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
