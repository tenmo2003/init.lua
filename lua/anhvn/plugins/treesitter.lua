---@diagnostic disable: missing-fields
return {
    {
        "romus204/tree-sitter-manager.nvim",
        dependencies = {}, -- tree-sitter CLI must be installed system-wide
        config = function()
            require("tree-sitter-manager").setup()
        end,
    },
    { "nvim-treesitter/nvim-treesitter-context", opts = {} },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        init = function()
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["ar"] = "@return.outer",
                        ["ir"] = "@return.inner",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>as"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>aS"] = "@parameter.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = false, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                    },
                },
            }
            -- selects
            vim.keymap.set({ "x", "o" }, "am", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "im", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ac", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ar", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@return.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ir", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@return.inner", "textobjects")
            end)

            -- swaps
            vim.keymap.set("n", "<leader>as", function()
                require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
            end)
            vim.keymap.set("n", "<leader>aS", function()
                require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
            end)

            -- moves
            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[m", function()
                require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[M", function()
                require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
            end)
        end,
    },
}
