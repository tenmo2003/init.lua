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

set("n", "<leader>fc", function()
    require("conform").format { bufnr = 0 }
    print "Formatted"
end, { desc = "Format with conform" })

set("n", "<leader>fb", "mzgg=G`z", { desc = "Built-in format" })

set("n", "<C-k>", "<cmd>cprev<CR>zz")
set("n", "<C-j>", "<cmd>cnext<CR>zz")
set("n", "<leader>k", "<cmd>lnext<CR>zz")
set("n", "<leader>j", "<cmd>lprev<CR>zz")

set(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Change all occurrences of word under the cursor" }
)
set(
    "v",
    "<leader>s",
    [["zy:%s/\<<C-r>z\>/<C-r>z/gI<Left><Left><Left>]],
    { desc = "Change all occurrences of selection" }
)
set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Set executable" })

set("n", "<leader>qc", function()
    vim.cmd "cclose"
    vim.fn.setqflist {}
end, { desc = "Close and clear quickfix list" })

set("n", "<leader>tn", function()
    vim.cmd "tabnew"
end)
set("n", "<leader>tc", function()
    vim.cmd "tabclose"
end)
