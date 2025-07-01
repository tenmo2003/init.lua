require("anhvn.set")
require("anhvn.statusline")
require("anhvn.remap")
require("anhvn.lazy-init")
require("anhvn.indentations")
require("anhvn.filetypes")

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
            timeout = 50,
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

_G.auto_organize_on_save_for_html = true -- an escape hatch so I can turn this functionality on/off

local function organize_imports_for_typescript()
    local ft = vim.bo.filetype:gsub("react$", "")
    if not vim.tbl_contains({ "javascript", "typescript" }, ft) then
        return
    end
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "",
    }

    local clients = vim.lsp.get_clients { name = "ts_ls" }
    if #clients == 0 then
        vim.notify("No ts_ls client found", vim.log.levels.ERROR)
        return
    end
    local client = clients[1]
    client:exec_cmd(params)
end

autocmd("BufWritePre", {
    pattern = { "*.css", "*.html", "*.js", "*.jsx", "*.json", "*.ts", "*.tsx" },
    callback = function()
        if not _G.auto_organize_on_save_for_html then
            return
        end
        require("conform").format({ async = false })
        organize_imports_for_typescript()
    end,
})
