return {
    -- {
    --     "Exafunction/windsurf.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "hrsh7th/nvim-cmp",
    --     },
    --     config = function()
    --         require("codeium").setup({
    --             virtual_text = {
    --                 enabled = true,
    --                 filetypes = {
    --                     oil = false
    --                 },
    --                 key_bindings = {
    --                     clear = "<C-]>",
    --                     accept_word = "<M-w>",
    --                     next = "<M-l>",
    --                     prev = "<M-h>",
    --                 }
    --             }
    --         })
    --     end
    -- },
    {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup {
                condition = function()
                    return vim.bo.filetype == "oil"
                end,
            }
        end,
    },
}
