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
}
