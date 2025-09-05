return {
    {
        "sindrets/diffview.nvim",
        opts = {
            use_icons = false,
        },
        config = function()
            vim.keymap.set("n", "<leader>gh", function()
                vim.cmd "DiffviewFileHistory %"
            end, { desc = "View current file git history" })
        end,
    },
}
