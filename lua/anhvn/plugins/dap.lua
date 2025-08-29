return {
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        keys = function()
            local dap = require "dap"
            return {
                { "[f", dap.up, desc = "Debug: DAP Up" },
                { "]f", dap.down, desc = "Debug: DAP Down" },
                {
                    "<leader>ds",
                    function()
                        local widgets = require "dap.ui.widgets"
                        widgets.centered_float(widgets.scopes, { border = "rounded" })
                    end,
                    desc = "Debug: DAP Scopes",
                },
                { "<F1>", require("dap.ui.widgets").hover, desc = "Debug: DAP Hover", mode = { "n", "v" } },
                {
                    "<F4>",
                    function()
                        dap.terminate { hierarchy = true }
                    end,
                    desc = "Debug: DAP Terminate",
                },
                { "<F5>", dap.continue, desc = "Debug: DAP Continue" },
                { "<F6>", dap.run_to_cursor, desc = "Debug: Run to Cursor" },
                {
                    "<F8>",
                    function()
                        dap.set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
                    end,
                    desc = "Debug: Toggle Logpoint",
                },
                { "<F9>", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
                { "<F10>", dap.step_over, desc = "Debug: Step Over" },
                { "<F11>", dap.step_into, desc = "Debug: Step Into" },
                { "<F12>", dap.step_out, desc = "Debug: Step Out" },
                {
                    "<leader>B",
                    function()
                        vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
                            dap.set_breakpoint(input)
                        end)
                    end,
                    desc = "Debug: Conditional Breakpoint",
                },
            }
        end,
        config = function()
            local dap = require "dap"
            -- dap.set_log_level "DEBUG"

            -- Setup

            -- Decides when and how to jump when stopping at a breakpoint
            -- The order matters!
            --
            -- (1) If the line with the breakpoint is visible, don't jump at all
            -- (2) If the buffer is opened in a tab, jump to it instead
            -- (3) Else, create a new tab with the buffer
            --
            -- This avoid unnecessary jumps
            dap.defaults.fallback.switchbuf = "usevisible,usetab,newtab"
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            ensure_installed = { "delve" },
            automatic_installation = true,
            handlers = {
                function(config)
                    require("mason-nvim-dap").default_setup(config)
                end,
                delve = function(config)
                    table.insert(config.configurations, 1, {
                        type = "delve",
                        name = "file",
                        request = "launch",
                        program = "${file}",
                        outputMode = "remote",
                    })
                    table.insert(config.configurations, 2, {
                        args = function()
                            return vim.split(vim.fn.input "args> ", " ")
                        end,
                        type = "delve",
                        name = "file args",
                        request = "launch",
                        program = "${file}",
                        outputMode = "remote",
                    })
                    require("mason-nvim-dap").default_setup(config)
                end,
            },
        },
    },
    {
        "igorlfs/nvim-dap-view",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {},
    },
}
