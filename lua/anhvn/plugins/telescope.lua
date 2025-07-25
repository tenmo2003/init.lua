return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup {
            pickers = {
                find_files = {
                    hidden = true,
                },
            },
        }
        local builtin = require "telescope.builtin"
        vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope find files" })
        vim.keymap.set("n", "<leader>pg", builtin.live_grep)
        vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope git files" })
        vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string { search = vim.fn.input "Grep > " }
        end, { desc = "Search string" })
        vim.keymap.set("n", "<leader>pws", function()
            local word = vim.fn.expand "<cword>"
            builtin.grep_string { search = word }
        end, { desc = "Search word under the cursor" })
        vim.keymap.set("n", "<leader>pWs", function()
            local word = vim.fn.expand "<cWORD>"
            builtin.grep_string { search = word }
        end, { desc = "Search WORD under the cursor" })
        vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "View help tags" })
        vim.keymap.set("n", "<leader>pc", builtin.git_commits, { desc = "View commits" })
        vim.keymap.set("n", "<leader>bd", function()
            builtin.diagnostics { bufnr = 0 }
        end, { desc = "View current buffer's diagnostics" })
        vim.keymap.set("n", "<leader>wd", builtin.diagnostics, { desc = "View all buffers' diagnostics" })
    end,
}
