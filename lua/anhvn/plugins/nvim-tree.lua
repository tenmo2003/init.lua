return {
    {
        "nvim-tree/nvim-tree.lua",
        lazy = true,
        keys = {
            { "<leader>nt", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toggle NvimTree" },
        },
        dependencies = {
            "nvim-mini/mini.icons",
        },
        config = function()
            local api = require "nvim-tree.api"

            local function edit_or_open()
                local node = api.tree.get_node_under_cursor()

                if node.nodes ~= nil then
                    -- expand or collapse folder
                    api.node.open.edit()
                else
                    -- open file
                    api.node.open.edit()
                    -- Close the tree if file was opened
                    api.tree.close()
                end
            end

            -- open as vsplit on current node
            local function vsplit_preview()
                local node = api.tree.get_node_under_cursor()

                if node.nodes ~= nil then
                    -- expand or collapse folder
                    api.node.open.edit()
                else
                    -- open file as vsplit
                    api.node.open.vertical()
                end

                -- Finally refocus on tree if it was lost
                api.tree.focus()
            end

            local function change_root_to_global_cwd()
                local global_cwd = vim.fn.getcwd(-1, -1)
                api.tree.change_root(global_cwd)
            end

            local function my_on_attach(bufnr)
                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end
                -- default mappings
                api.config.mappings.default_on_attach(bufnr)

                vim.keymap.set("n", "_", change_root_to_global_cwd, opts "Change root to global cwd")
                vim.keymap.set("n", "l", edit_or_open, opts "Edit Or Open")
                vim.keymap.set("n", "L", vsplit_preview, opts "Vsplit Preview")
            end

            require("nvim-tree").setup {
                disable_netrw = true,
                on_attach = my_on_attach,
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
