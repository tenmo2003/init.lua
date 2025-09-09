return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup {
            on_attach = function(bufnr)
                local gitsigns = require "gitsigns"

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal { "]c", bang = true }
                    else
                        gitsigns.nav_hunk "next"
                    end
                end, { desc = "Go to next hunk" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal { "[c", bang = true }
                    else
                        gitsigns.nav_hunk "prev"
                    end
                end, { desc = "Go to prev hunk" })

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
                map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
                end, { desc = "Stage selected hunk" })

                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
                end, { desc = "Reset selected hunk" })

                map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage entire buffer" })
                map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset entire buffer" })
                map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
                map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Inline preview hunk" })

                map("n", "<leader>hb", function()
                    gitsigns.blame_line { full = true }
                end, { desc = "Show full blame for current line" })

                map("n", "<leader>hd", gitsigns.diffthis, { desc = "Show diff against index" })

                map("n", "<leader>hD", function()
                    gitsigns.diffthis "~"
                end, { desc = "Show diff against last commit" })

                map("n", "<leader>hQ", function()
                    gitsigns.setqflist "all"
                end, { desc = "Set quickfix list (all hunks)" })

                map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set quickfix list (current buffer)" })

                -- Toggles
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
                map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

                -- Text object
                map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk" })
            end,
        }
    end,
}
