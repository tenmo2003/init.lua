return {
    {
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup {
                use_icons = false,
            }

            vim.keymap.set("n", "<leader>fh", function()
                vim.cmd "DiffviewFileHistory %"
            end, { desc = "View current file history from git" })
        end,
    },
}
