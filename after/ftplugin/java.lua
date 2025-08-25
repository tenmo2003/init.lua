local home = vim.loop.os_uname().sysname == "Windows_NT" and os.getenv "USERPROFILE" -- Windows
    or os.getenv "HOME" -- Unix-like

local jdk8_home = "/opt/jdk-8"
local jdk11_home = "/opt/jdk-11"
local jdk21_home = "/opt/jdk-21.0.6"

vim.uv.os_setenv("JAVA_HOME", jdk21_home)

local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

local jdtls_path = vim.fs.joinpath(vim.fn.stdpath "data", "mason", "packages", "jdtls")

local status, jdtls = pcall(require, "jdtls")
if not status then
    return
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities

local config = {
    cmd = {
        jdk21_home .. "/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. vim.fs.joinpath(jdtls_path, "lombok.jar"),
        "-jar",
        vim.fn.glob(vim.fs.joinpath(jdtls_path, "plugins", "org.eclipse.equinox.launcher_*.jar")),
        "-configuration",
        vim.fs.joinpath(jdtls_path, "config_linux"),
        "-data",
        workspace_dir,
    },
    root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },

    settings = {
        java = {
            signatureHelp = { enabled = true },
            extendedClientCapabilities = extendedClientCapabilities,
            maven = {
                downloadSources = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all", -- literals, all, none
                },
            },
            format = {
                enabled = false,
            },
            configuration = {
                -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                -- And search for `interface RuntimeOption`
                -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = jdk8_home,
                    },
                    {
                        name = "JavaSE-11",
                        path = jdk11_home,
                    },
                    {
                        name = "JavaSE-21",
                        path = jdk21_home,
                        default = true,
                    },
                },
            },
        },
    },

    init_options = {
        bundles = {},
    },
}
require("jdtls").start_or_attach(config)

vim.keymap.set("n", "<S-M-o>", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "Organize Imports" })
vim.keymap.set("n", "<leader>ev", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "Extract Variable" })
vim.keymap.set(
    "v",
    "<leader>ev",
    "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
    { desc = "Extract Variable" }
)
vim.keymap.set("n", "<leader>ec", "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = "Extract Constant" })
vim.keymap.set(
    "v",
    "<leader>ec",
    "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
    { desc = "Extract Constant" }
)
vim.keymap.set(
    "v",
    "<leader>em",
    "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
    { desc = "Extract Method" }
)
