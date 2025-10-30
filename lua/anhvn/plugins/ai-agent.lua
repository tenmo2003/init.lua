return {
    -- lazy.nvim
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = function()
            vim.keymap.set({ "n", "v" }, "<leader>cca", "<cmd>CodeCompanionActions<cr>")
            vim.keymap.set({ "n", "v" }, "<leader>cct", "<cmd>CodeCompanionChat Toggle<cr>")
            return {
                adapters = {
                    http = {
                        anthropic = function()
                            return require("codecompanion.adapters").extend("anthropic", {
                                schema = {
                                    model = {
                                        default = "claude-sonnet-4-5-20250929",
                                    },
                                },
                            })
                        end,
                    },
                },
                -- NOTE: The log_level is in `opts.opts`
                -- opts = {
                --     log_level = "DEBUG", -- or "TRACE"
                -- },
                strategies = {
                    chat = {
                        adapter = "anthropic",
                        model = "claude-sonnet-4-5-20250929",
                        -- model = "claude-sonnet-4-20250514",
                    },
                    inline = {
                        adapter = "anthropic",
                    },
                },
                display = {
                    chat = {
                        window = {
                            position = "right",
                        },
                    },
                },
            }
        end,
    },
}
