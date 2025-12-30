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
            local signs = {
                DapBreakpoint = { text = "B", texthl = "WarningMsg", linehl = "", numhl = "" },
                DapBreakpointCondition = { text = "C", texthl = "WarningMsg", linehl = "", numhl = "" },
                DapBreakpointRejected = { text = "R", texthl = "WarningMsg", linehl = "", numhl = "" },
                DapLogPoint = { text = "L", texthl = "WarningMsg", linehl = "", numhl = "" },
                DapStopped = { text = "→", texthl = "WarningMsg", linehl = "debugPC", numhl = "" },
            }

            for type, sign in pairs(signs) do
                vim.fn.sign_define(type, sign)
            end

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
        "igorlfs/nvim-dap-view",
        lazy = false,
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {
            winbar = {
                sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
                controls = {
                    enabled = true,
                },
            },
        },
        keys = function()
            local dap_view = require "dap-view"
            return {
                {
                    "<leader>du",
                    function()
                        dap_view.toggle(true)
                    end,
                    desc = "Debug: Toggle View",
                },
            }
        end,
    },
}
