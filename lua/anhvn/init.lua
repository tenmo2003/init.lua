require("anhvn.set")
require("anhvn.remap")
require("anhvn.lazy-init")

local augroup = vim.api.nvim_create_augroup
local anhvn = augroup('anhvn', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 80,
        })
    end,
})

autocmd("BufWritePre", {
    group = anhvn,
    pattern = "*",
    callback = function()
        -- Remove trailing whitespace from lines
        vim.cmd([[%s/\s\+$//e]])
        -- Remove all blank lines at the end of the file
        vim.cmd([[%s/\($\n\s*\)\+\%$//e]])
    end,
})

autocmd('LspAttach', {
    group = anhvn,
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
        { desc = "Go to definition", buffer = opts.buffer })

        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
        { desc = "Show hover information", buffer = opts.buffer })

        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
        { desc = "Search workspace symbols", buffer = opts.buffer })

        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
        { desc = "Code action", buffer = opts.buffer })

        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
        { desc = "List references", buffer = opts.buffer })

        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end,
        { desc = "Rename symbol", buffer = opts.buffer })

        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
        { desc = "Show diagnostics in a floating window", buffer = opts.buffer })

        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
        { desc = "Signature help", buffer = opts.buffer })

        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end,
        { desc = "Go to previous diagnostic", buffer = opts.buffer })

        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end,
        { desc = "Go to next diagnostic", buffer = opts.buffer })
    end
})
