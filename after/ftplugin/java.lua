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

local java_debug_path = vim.fs.joinpath(
    vim.fn.stdpath "data",
    "mason",
    "packages",
    "java-debug-adapter",
    "extension",
    "server",
    "com.microsoft.java.debug.plugin-*.jar"
)

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
    root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew" } or require("jdtls.setup").find_root {
        "pom.xml",
        "build.gradle",
        "build.xml",
        "settings.gradle",
        "settings.gradle.kts",
    }, -- priorize multi-module projects

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
        bundles = {
            vim.fn.glob(java_debug_path, true),
        },
    },

    on_attach = function(client, bufnr)
        vim.hl.priorities.semantic_tokens = 95
        -- client.server_capabilities.semanticTokensProvider = nil
    end,
}
require("jdtls").start_or_attach(config)

vim.keymap.set("n", "<S-M-o>", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "Organize Imports" })
vim.keymap.set("n", "<leader>evs", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "Extract Variable" })
vim.keymap.set(
    "v",
    "<leader>evs",
    "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
    { desc = "Extract Variable" }
)
vim.keymap.set(
    "n",
    "<leader>eva",
    "<Cmd>lua require('jdtls').extract_variable_all()<CR>",
    { desc = "Extract Variable For All Occurrences" }
)
vim.keymap.set(
    "v",
    "<leader>eva",
    "<Esc><Cmd>lua require('jdtls').extract_variable_all(true)<CR>",
    { desc = "Extract Variable For All Occurrences" }
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

vim.cmd [[setlocal makeprg=mvn\ clean\ compile]]

require "anhvn.dap.java"

if vim.g.java_run_main_command then
    return
end

vim.g.java_run_main_command = true

vim.api.nvim_create_user_command("RunMain", function(args)
    local buf = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[buf].filetype

    -- Check if current file is Java
    if filetype ~= "java" then
        vim.notify("RunMain: Not a Java file", vim.log.levels.ERROR)
        return
    end

    local filepath = vim.fn.expand "%:p"
    local filename = vim.fn.expand "%:t:r" -- filename without extension

    -- Extract package from file path
    local package_path = filepath:match "src/main/java/(.+)/[^/]+%.java$"
    if not package_path then
        package_path = filepath:match "src/java/(.+)/[^/]+%.java$"
    end

    if not package_path then
        vim.notify("RunMain: Could not determine package structure", vim.log.levels.ERROR)
        return
    end

    -- Convert path to package name
    local package_name = package_path:gsub("/", ".")
    local fully_qualified_class = package_name .. "." .. filename

    -- Find project root (directory containing src/)
    local project_root = filepath:match "(.+)/src/"
    if not project_root then
        vim.notify("RunMain: Could not find project root", vim.log.levels.ERROR)
        return
    end

    -- Check if it's a Maven/Gradle project
    local has_maven = vim.fn.filereadable(project_root .. "/pom.xml") == 1
    local has_gradle = vim.fn.filereadable(project_root .. "/build.gradle") == 1
        or vim.fn.filereadable(project_root .. "/build.gradle.kts") == 1

    local cmd
    if has_maven then
        -- Use Maven exec plugin
        cmd = string.format(
            "cd %s && mvn exec:java -Dexec.mainClass=%s",
            vim.fn.shellescape(project_root),
            fully_qualified_class
        )
    elseif has_gradle then
        -- Use Gradle run task (requires application plugin)
        cmd = string.format(
            "cd %s && ./gradlew run -PmainClass=%s",
            vim.fn.shellescape(project_root),
            fully_qualified_class
        )
    else
        -- Fallback: use javac + java
        cmd = string.format(
            "cd %s && javac -d target/classes %s && java -cp target/classes %s",
            vim.fn.shellescape(project_root),
            vim.fn.shellescape(filepath),
            fully_qualified_class
        )
    end

    -- Allow passing additional arguments
    if args.args ~= "" then
        cmd = cmd .. " " .. args.args
    end

    -- Run in terminal split
    vim.cmd "belowright 15split"
    vim.cmd("terminal " .. 'echo "Running: ' .. fully_qualified_class .. '" && ' .. cmd)
end, {
    desc = "Run Java Main Method",
    nargs = "*", -- Allow additional arguments
})
