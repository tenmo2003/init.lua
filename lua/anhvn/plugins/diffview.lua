return {
    {
        "sindrets/diffview.nvim",
        opts = {
            use_icons = false,
        },
        keys = {
            {
                "<leader>gh",
                function()
                    vim.cmd "DiffviewFileHistory %"
                end,
                desc = "View current file git history",
            },
        },
    },
}
