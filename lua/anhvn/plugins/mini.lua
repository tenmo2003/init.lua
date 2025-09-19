return {
    {
        "nvim-mini/mini.ai",
        version = false,
        opts = {
            custom_textobjects = {
                g = function()
                    local from = { line = 1, col = 1 }
                    local to = {
                        line = vim.fn.line "$",
                        col = math.max(vim.fn.getline("$"):len(), 1),
                    }
                    return { from = from, to = to }
                end,
            },
            n_lines = 80,
        },
    },
    {
        "nvim-mini/mini.splitjoin",
        version = false,
        opts = {
            detect = {
                exclude_regions = { "%b()", "%b[]", "%b{}", '%b""', "%b''", "%b<>" },
            },
        },
    },
    {
        "nvim-mini/mini.surround",
        version = false,
        opts = {},
    },
    {
        "nvim-mini/mini.icons",
        config = function()
            require("mini.icons").setup()
            MiniIcons.mock_nvim_web_devicons()
        end,
    },
    {
        "nvim-mini/mini.files",
        version = false,
        config = function()
            local mini_files = require "mini.files"

            mini_files.setup {
                mappings = {
                    go_in = "L",
                    go_in_plus = "l",
                },
            }
            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesWindowUpdate",
                callback = function(args)
                    vim.wo[args.data.win_id].relativenumber = true
                end,
            })

            vim.api.nvim_create_autocmd("BufWinEnter", {
                pattern = "*",
                callback = function()
                    if vim.bo.ft ~= "minifiles" then
                        return
                    end

                    local bufnr = vim.api.nvim_get_current_buf()
                    local opts = { buffer = bufnr, remap = false }

                    vim.keymap.set("n", "-", function()
                        mini_files.go_out()
                        mini_files.trim_right()
                    end, opts)

                    vim.keymap.set("n", "_", function()
                        mini_files.open(vim.uv.cwd(), false)
                    end, opts)

                    vim.keymap.set("n", "<CR>", function()
                        mini_files.go_in { close_on_file = true }
                    end)
                end,
            })

            vim.keymap.set("n", "-", function()
                mini_files.open(vim.api.nvim_buf_get_name(0), true)
            end, { desc = "Open mini.files at current directory" })
        end,
    },
}
