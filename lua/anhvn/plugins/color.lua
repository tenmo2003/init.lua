local function colorscheme_autocmd(colorscheme_pattern, additional_callback)
    if not additional_callback or type(additional_callback) ~= "function" then
        return
    end

    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd
    local anhvn = augroup("colorscheme-" .. colorscheme_pattern, {})

    autocmd("ColorScheme", {
        group = anhvn,
        pattern = colorscheme_pattern,
        callback = function()
            additional_callback()
        end,
    })
end

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            U = require "catppuccin.utils.colors"
            require("catppuccin").setup {
                custom_highlights = function(colors)
                    return {
                        LineNr = { fg = colors.text },
                        LineNrAbove = { fg = colors.surface2 },
                        LineNrBelow = { fg = colors.surface2 },
                        Pmenu = { bg = U.darken(colors.surface0, 0.8, colors.crust), fg = colors.overlay2 },
                        PmenuSel = { bg = colors.surface1 },
                        debugPC = { bg = colors.surface1 },
                    }
                end,
            }
            vim.cmd.colorscheme "catppuccin-macchiato"
        end,
    },
    {
        "vague2k/vague.nvim",
        config = function()
            colorscheme_autocmd("vague", function()
                vim.cmd.hi "StatusLine guibg=NONE"
            end)
            -- vim.cmd.colorscheme "vague"
        end,
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            -- vim.cmd.colorscheme "tokyonight-night"
        end,
    },
}
