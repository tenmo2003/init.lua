local ok, dap = pcall(require, "dap")
if not ok then
    return
end

dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
        command = vim.fn.exepath "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
    },
}

dap.configurations.go = dap.configurations.go or {}
local go_dap_configurations = {
    {
        type = "delve",
        name = "file",
        request = "launch",
        program = "${file}",
        outputMode = "remote",
    },
    {
        args = function()
            return vim.split(vim.fn.input "args> ", " ")
        end,
        type = "delve",
        name = "file args",
        request = "launch",
        program = "${file}",
        outputMode = "remote",
    },
    {
        type = "delve",
        name = "Delve: Debug",
        request = "launch",
        program = "${workspaceFolder}",
    },
    {
        type = "delve",
        name = "Delve: Debug (Arguments)",
        request = "launch",
        program = "${workspaceFolder}",
        args = function()
            return vim.split(vim.fn.input "Args: ", " ")
        end,
    },
    {
        type = "delve",
        name = "Delve: Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}",
    },
    -- works with go.mod packages and sub packages
    {
        type = "delve",
        name = "Delve: Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
    },
}
for _, config in ipairs(go_dap_configurations) do
    table.insert(dap.configurations.go, config)
end
