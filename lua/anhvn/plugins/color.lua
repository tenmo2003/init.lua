return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup {
                custom_highlights = function(colors)
                    return {
                        LineNr = { fg = colors.text },
                        LineNrAbove = { fg = colors.surface2 },
                        LineNrBelow = { fg = colors.surface2 },
                    }
                end,
            }
            -- vim.cmd.colorscheme "catppuccin-macchiato"
        end,
    },
    {
        "vague2k/vague.nvim",
        config = function()
            vim.cmd.colorscheme "vague"
            vim.cmd ":hi statusline guibg=NONE"
        end,
    },
}
