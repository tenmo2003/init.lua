local root_files = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require "cmp"
        local cmp_lsp = require "cmp_nvim_lsp"
        local lspconfig = require "lspconfig"
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup {}
        require("mason").setup()

        local language_servers = {
            bashls = true,
            lua_ls = true,
            gopls = true,
            rust_analyzer = {
                manual_install = true,
            },
            ts_ls = true,
            tailwindcss = true,
            emmet_language_server = true,
        }

        local servers_to_install = vim.tbl_filter(function(key)
            local t = language_servers[key]
            if type(t) == "table" then
                return not t.manual_install
            else
                return t
            end
        end, vim.tbl_keys(language_servers))

        local other_tools = {
            formatters = {
                "stylua",
                "prettierd",
            },
            linters = {
                "sonarlint-language-server",
            },
        }

        local ensure_installed = servers_to_install
        for _, group in pairs(other_tools) do
            vim.list_extend(ensure_installed, group)
        end

        for name, config in pairs(language_servers) do
            if config == true then
                config = {}
            end
            config = vim.tbl_deep_extend("force", {}, {
                capabilities = capabilities,
            }, config)

            lspconfig[name].setup(config)
        end

        require("mason-tool-installer").setup {
            ensure_installed = ensure_installed,
        }

        require("mason-lspconfig").setup {
            automatic_enable = true,
        }

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup {
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<Tab>"] = cmp.mapping.confirm { select = true },
                ["<C-Space>"] = cmp.mapping.complete(),
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
                { name = "codeium", group_index = 3 },
                { name = "copilot", group_index = 2 },
            }, {
                { name = "buffer" },
            }),
            window = {
                completion = {
                    scrolloff = 3,
                },
            },
        }

        cmp.setup.filetype("oil", {
            sources = {
                { name = "buffer" },
                { name = "path" },
            },
        })

        vim.diagnostic.config {
            virtual_text = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        }
    end,
}
