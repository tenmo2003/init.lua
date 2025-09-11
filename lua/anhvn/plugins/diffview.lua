return {
    {
        "sindrets/diffview.nvim",
        config = function()
            local actions = require "diffview.actions"

            require("diffview").setup {
                use_icons = false,
                keymaps = {
                    view = {
                        {
                            "n",
                            "<leader>cc",
                            actions.conflict_choose "all",
                            { desc = "Choose all the versions of a conflict" },
                        },
                        {
                            "n",
                            "<leader>cC",
                            actions.conflict_choose_all "all",
                            { desc = "Choose all the versions of a conflict for the whole file" },
                        },
                    },
                },
            }

            vim.keymap.set("n", "<leader>fh", function()
                vim.cmd "DiffviewFileHistory %"
            end, { desc = "View current file history from git" })

            vim.keymap.set("n", "<leader>do", function()
                vim.cmd "DiffviewOpen"
            end, { desc = "Open diffview (mainly for resolving conflicts)" })
        end,
    },
}
