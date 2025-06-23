return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000 ,
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end
    },
    -- {
    --     "vague2k/vague.nvim",
    --     config = function()
    --         vim.cmd.colorscheme "vague"
    --     end
    -- },
}
