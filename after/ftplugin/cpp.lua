-- %:r is the current file name without extension
vim.keymap.set("n", "<leader>rm", function()
    if vim.g.run_main_term_buf and vim.api.nvim_buf_is_valid(vim.g.run_main_term_buf) then
        vim.api.nvim_buf_delete(vim.g.run_main_term_buf, { force = true })
    end

    vim.cmd "update"
    vim.cmd 'belowright 15split | terminal g++ -o %:r %:p && echo "Running: %:r" && ./%:r'
    vim.g.run_main_term_buf = vim.api.nvim_get_current_buf()
end, { desc = "Compile and run current file" })
