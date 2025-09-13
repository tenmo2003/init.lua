vim.g.mapleader = " " -- lazy requires this

require "anhvn.lazy-init"

local augroup = vim.api.nvim_create_augroup
local anhvn = augroup("anhvn", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank {
            higroup = "IncSearch",
            timeout = 50,
        }
    end,
})

autocmd("BufWritePre", {
    group = anhvn,
    pattern = "*",
    callback = function()
        -- Remove trailing whitespace from lines
        vim.cmd [[%s/\s\+$//e]]
        -- Remove all blank lines at the end of the file
        vim.cmd [[%s/\($\n\s*\)\+\%$//e]]
    end,
})

vim.diagnostic.config {
    virtual_text = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
}

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

autocmd("BufEnter", {
    pattern = { "*.css", "*.html", "*.js", "*.jsx", "*.json", "*.ts", "*.tsx" },
    group = anhvn,
    callback = function()
        vim.api.nvim_create_user_command("OrganizeImports", function()
            organize_imports_for_typescript()
            vim.notify "Organized imports"
        end, {})

        vim.keymap.set("n", "<S-M-o>", ":OrganizeImports<CR>", { buffer = true })
    end,
})
