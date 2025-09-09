return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")
        vim.keymap.set("n", "<leader>gl", ":Gclog<CR>")

        local anhvn_fugitive = vim.api.nvim_create_augroup("anhvn_fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = anhvn_fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "<leader>gp", function()
                    vim.cmd.Git "push"
                end, opts)

                vim.keymap.set("n", "<leader>gl", function()
                    vim.cmd.Git "pull"
                end, opts)

                -- rebase always
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git { "pull", "--rebase" }
                end, opts)

                -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                -- needed if i did not set the branch up correctly
                vim.keymap.set("n", "<leader>po", ":Git push -u origin ", opts)
            end,
        })

        vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>")
    end,
}
