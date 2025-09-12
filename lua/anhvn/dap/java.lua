local ok, dap = pcall(require, "dap")
if not ok then
    return
end

dap.configurations.java = dap.configurations.java or {}
table.insert(dap.configurations.java, {
    type = "java",
    request = "attach",
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = function()
        return vim.fn.input("Debug Port: ", "8000")
    end,
})
