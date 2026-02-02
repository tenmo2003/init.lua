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

autocmd("ColorScheme", {
    group = augroup("anhvn_general_colorscheme_autocmd", {}),
    pattern = "*",
    callback = function()
        vim.cmd.source(vim.fn.stdpath "config" .. "/plugin/statusline.lua")
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

autocmd("LspAttach", {
    group = augroup("OnLSPAttach", {}),
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "gD", function()
            vim.lsp.buf.declaration()
        end, { buffer = opts.buffer, desc = "Go to declaration" })

        vim.keymap.set("n", "<leader>gt", function()
            vim.lsp.buf.type_definition()
        end, { buffer = opts.buffer, desc = "Go to type definition" })

        vim.keymap.set(
            "n",
            "gd",
            require("telescope.builtin").lsp_definitions,
            { desc = "Go to definition", buffer = opts.buffer }
        )

        vim.keymap.set(
            "n",
            "gI",
            require("telescope.builtin").lsp_implementations,
            { desc = "Go to implementations", buffer = opts.buffer }
        )

        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover { border = "rounded" }
        end, { desc = "Show hover information", buffer = opts.buffer })

        vim.keymap.set(
            "n",
            "<leader>bs",
            require("telescope.builtin").lsp_document_symbols,
            { desc = "Search document symbols", buffer = opts.buffer }
        )

        vim.keymap.set(
            "n",
            "<leader>ws",
            require("telescope.builtin").lsp_dynamic_workspace_symbols,
            { desc = "Search workspace symbols", buffer = opts.buffer }
        )

        vim.keymap.set({ "n", "x" }, "<leader>ca", function()
            vim.lsp.buf.code_action()
        end, { desc = "Code action", buffer = opts.buffer })

        vim.keymap.set(
            "n",
            "<leader>gr",
            require("telescope.builtin").lsp_references,
            { desc = "List references", buffer = opts.buffer }
        )

        vim.keymap.set("n", "<leader>rn", function()
            vim.lsp.buf.rename()
        end, { desc = "Rename symbol", buffer = opts.buffer })

        vim.keymap.set("n", "<F2>", function()
            vim.lsp.buf.rename()
        end, { desc = "Rename symbol", buffer = opts.buffer })

        vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help { border = "rounded" }
        end, { desc = "Signature help", buffer = opts.buffer })

        vim.keymap.set("n", "<M-h>", function()
            vim.lsp.buf.signature_help { border = "rounded" }
        end, { desc = "Signature help", buffer = opts.buffer })
    end,
})

-- Automatically update files when changed elsewhere
vim.cmd [[set autoread]]
vim.cmd [[autocmd FocusGained * checktime]]

local shada_path = vim.fn.stdpath "state" .. "/shada/"
vim.fn.mkdir(shada_path, "p")

local cwd = vim.fn.getcwd():gsub("/", "%%"):gsub(":", "%%")
vim.opt.shadafile = shada_path .. cwd .. ".shada"
