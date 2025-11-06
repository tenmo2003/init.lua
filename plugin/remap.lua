local set = vim.keymap.set

set("n", "<leader>pv", vim.cmd.Ex)

set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move current line down" })
set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move current line up" })
set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move current line down" })
set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move current line up" })

set("n", "J", "mzJ`z")
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

-- next greatest remap ever : asbjornHaland
set({ "n", "v" }, "<leader>y", [["+y]])
set("n", "<leader>Y", [["+Y]])

set({ "n", "v" }, "<leader>d", '"_d')

-- This is going to get me cancelled
set("i", "<C-c>", "<Esc>")

set("n", "Q", "<nop>")
set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
set("n", "<C-h>", "<cmd>silent !tmux neww tmux-cht.sh<CR>")
set("n", "<M-g>", "<cmd>!open-git-remote.sh<CR>")

set("n", "<leader>fb", "mzgg=G`z", { desc = "Built-in format" })

set("n", "<C-k>", "<cmd>cprev<CR>zz")
set("n", "<C-j>", "<cmd>cnext<CR>zz")
set("n", "<leader>k", "<cmd>lnext<CR>zz")
set("n", "<leader>j", "<cmd>lprev<CR>zz")

set(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Change all occurrences of word under cursor" }
)
set("v", "<leader>s", [["zy:%s/<C-r>z/<C-r>z/gI<Left><Left><Left>]], { desc = "Change all occurrences of selection" })

set("n", "<C-n>", [[/\<<C-r><C-w>\><CR>]], { desc = "Search for word under cursor" })
set("v", "<C-n>", [["zy/<C-r>z<CR>]], { desc = "Search for selection" })
set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Set executable" })

set("n", "<leader>qc", function()
    vim.cmd "cclose"
    -- vim.fn.setqflist {}
end, { desc = "Close quickfix list" })

set("n", "<leader>qo", function()
    vim.cmd "copen"
end, { desc = "Open quickfix list" })

set("n", "<leader>tn", function()
    vim.cmd "tabnew"
end, { desc = "Open new tab" })
set("n", "<leader>tc", function()
    vim.cmd "tabclose"
end, { desc = "Close current tab" })

set("n", "<leader>vd", function()
    vim.diagnostic.open_float()
end, { desc = "Show diagnostics in a floating window" })
set("n", "[d", function()
    vim.diagnostic.jump { count = -1, float = true }
end, { desc = "Go to previous diagnostic" })

set("n", "]d", function()
    vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Go to next diagnostic" })
