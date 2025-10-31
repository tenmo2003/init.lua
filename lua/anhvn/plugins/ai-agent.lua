return {
    {
        "augmentcode/augment.vim",
        dependencies = { { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } } },
        config = function()
            vim.keymap.set("n", "<leader>at", "<cmd>Augment chat-toggle<cr>")
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "MeanderingProgrammer/render-markdown.nvim",
                ft = { "markdown", "codecompanion" },
            },
        },
        opts = function()
            local set = function(mode, lhs, rhs)
                vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
            end

            set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>")
            set({ "n", "v" }, "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>")
            set("v", "ga", "<cmd>CodeCompanionChat Add<cr>")

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
                        keymaps = {
                            close = {
                                modes = { n = "<C-c>", i = "<End>" },
                                opts = {},
                            },
                        },
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
