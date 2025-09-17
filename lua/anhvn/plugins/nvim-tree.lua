return {
    {
        "nvim-tree/nvim-tree.lua",
        lazy = true,
        keys = {
            { "<leader>nt", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toggle NvimTree" },
        },
        config = function()
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            local function my_on_attach(bufnr)
                local api = require "nvim-tree.api"

                -- default mappings
                api.config.mappings.default_on_attach(bufnr)
            end

            require("nvim-tree").setup {
                on_attach = my_on_attach,
                disable_netrw = true,
                view = {
                    number = true,
                    relativenumber = true,
                    side = "right",
                    width = "50%",
                },
                renderer = {
                    group_empty = true,
                },
            }
        end,
    },
}
