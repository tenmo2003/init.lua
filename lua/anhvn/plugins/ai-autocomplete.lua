return {
    -- {
    --     "Exafunction/windsurf.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "hrsh7th/nvim-cmp",
    --     },
    --     config = function()
    --         require("codeium").setup {
    --             enable_cmp_source = false,
    --             virtual_text = {
    --                 enabled = true,
    --                 filetypes = {
    --                     oil = false,
    --                 },
    --                 key_bindings = {
    --                     accept = "<S-Tab>",
    --                     clear = "<C-]>",
    --                     accept_word = "<M-w>",
    --                     next = "<M-l>",
    --                     prev = "<M-h>",
    --                 },
    --             },
    --         }
    --     end,
    -- },
    {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup {
                ignore_filetypes = {
                    oil = true,
                    git = true,
                },
                keymaps = {
                    accept_suggestion = "<S-Tab>",
                },
            }
        end,
    },
}
