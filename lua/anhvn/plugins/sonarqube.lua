return {
    {
        "iamkarasik/sonarqube.nvim",
        ft = "java",
        config = function()
            local extension_dir = vim.fn.stdpath "data" .. "/sonarqube/extension"
            local mason_bin_dir = vim.fn.stdpath "data" .. "/mason/bin"

            local opts = {}

            local language_analyzers = {
                csharp = { "sonarcsharp.jar" },
                go = { "sonargo.jar" },
                html = { "sonarhtml.jar" },
                iac = { "sonariac.jar" },
                java = { "sonarjava.jar", "sonarjavasymbolicexecution.jar" },
                javascript = { "sonarjs.jar" },
                php = { "sonarphp.jar" },
                python = { "sonarpython.jar" },
                text = { "sonartext.jar" },
                xml = { "sonarxml.jar" },
            }

            local disabled = {
                "csharp",
                "go",
                "html",
                "iac",
                "javascript",
                "php",
                "python",
                "text",
                "xml",
            }

            for _, lang in ipairs(disabled) do
                opts[lang] = {
                    enabled = false,
                }
            end

            local enabled_analyzers = {}
            for lang, analyzers in pairs(language_analyzers) do
                if vim.tbl_contains(disabled, lang) then
                    goto continue
                end

                for _, analyzer in ipairs(analyzers) do
                    table.insert(enabled_analyzers, vim.fs.joinpath(extension_dir, "analyzers", analyzer))
                end

                ::continue::
            end

            opts.lsp = {
                cmd = {
                    mason_bin_dir .. "/java",
                    "-jar",
                    extension_dir .. "/server/sonarlint-ls.jar",
                    "-stdio",
                    "-analyzers",
                    table.concat(enabled_analyzers, " "),
                },
            }

            require("sonarqube").setup(opts)
        end,
    },
}
