return {
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup {
                -- disable netrw at the very start of your init.lua
                disable_netrw = true,
                hijack_netrw = true,
                hijack_unnamed_buffer_when_opening = true,
                sort_by = "case_sensitive",
                view = {
                    width = 30,
                    side = "left",
                    preserve_window_proportions = false,
                    number = false,
                    relativenumber = false,
                    signcolumn = "yes",
                },
                renderer = {
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                            modified = true,
                            hidden = false,
                            diagnostics = true,
                            bookmarks = true,
                        },
                        glyphs = {
                            default = "",
                            symlink = "",
                            bookmark = "󰆤",
                            modified = "●",
                            hidden = "󰜌",
                            folder = {
                                arrow_closed = "",
                                arrow_open = "",
                                default = "",
                                open = "",
                                empty = "",
                                empty_open = "",
                                symlink = "",
                                symlink_open = "",
                            },
                            git = {
                                unstaged = "✗",
                                staged = "✓",
                                unmerged = "",
                                renamed = "➜",
                                untracked = "★",
                                deleted = "",
                                ignored = "◌",
                            },
                        },
                    },
                },
            }
        end,
    },
}
