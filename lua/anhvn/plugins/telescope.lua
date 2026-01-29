return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            require("telescope").setup {
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
                defaults = {
                    path_display = { "truncate", "filename_first" },
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                        },
                    },
                    sorting_strategy = "ascending",
                },
            }
            local set = vim.keymap.set
            local builtin = require "telescope.builtin"
            -- Project related keymaps
            set("n", "<leader>pf", builtin.find_files, { desc = "Telescope find files" })
            set("n", "<leader>pif", function()
                builtin.find_files { no_ignore = true }
            end, { desc = "Telescope find files including ignored" })
            set("n", "<leader>pg", builtin.live_grep, { desc = "Telescope live grep" })
            set("n", "<C-p>", builtin.git_files, { desc = "Telescope git files" })
            set("n", "<leader>ps", function()
                builtin.grep_string { search = vim.fn.input "Grep > " }
            end, { desc = "Search string" })
            set("v", "<leader>ps", function()
                builtin.grep_string()
            end, { desc = "Search selection" })
            set("n", "<leader>pws", function()
                local word = vim.fn.expand "<cword>"
                builtin.grep_string { search = word }
            end, { desc = "Search word under the cursor" })
            set("n", "<leader>pWs", function()
                local word = vim.fn.expand "<cWORD>"
                builtin.grep_string { search = word }
            end, { desc = "Search WORD under the cursor" })
            set("n", "<leader>pc", builtin.git_commits, { desc = "Telescope: commits" })
            set("n", "<leader>pb", function()
                builtin.buffers { sort_mru = true }
            end, { desc = "Telescope: buffers" })
            set("n", "<leader>bd", function()
                builtin.diagnostics { bufnr = 0 }
            end, { desc = "View current buffer's diagnostics" })
            set("n", "<leader>wd", builtin.diagnostics, { desc = "View all buffers' diagnostics" })

            -- General keymaps
            set("n", "<leader>th", builtin.help_tags, { desc = "Telescope: help tags" })
            set("n", "<leader>tr", builtin.resume, { desc = "Telescope: resume" })
            set("n", "<leader>tk", builtin.keymaps, { desc = "Telescope: keymaps" })

            -- Telescope extensions
            require("telescope").load_extension "fzf"

            vim.api.nvim_create_autocmd("User", {
                pattern = "TelescopeFindPre",
                callback = function()
                    if _G.MiniFiles then
                        _G.MiniFiles.close()
                    end
                end,
            })
        end,
    },
}
