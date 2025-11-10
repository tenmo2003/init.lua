return {
    {
        "iamkarasik/sonarqube.nvim",
        config = function()
            local opts = {}

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

            require("sonarqube").setup(opts)
        end,
    },
}
