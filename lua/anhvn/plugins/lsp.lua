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
                "goimports",
            },
            linters = {
                "sonarlint-language-server",
            },
        }

        local ensure_installed = servers_to_install
        for _, group in pairs(other_tools) do
            vim.list_extend(ensure_installed, group)
        end

        require("mason-tool-installer").setup {
            ensure_installed = ensure_installed,
        }

        -- NOTE: refer to https://neovim.io/doc/user/lsp.html#lsp-config
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        for name, config in pairs(language_servers) do
            if config == true then
                config = {}
            end
            vim.lsp.config(name, config)
        end

        require("mason-lspconfig").setup {
            automatic_enable = {
                exclude = { "jdtls" },
            },
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
                -- { name = "supermaven", group_index = 3 },
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

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("OnLSPAttach", {}),
            callback = function(e)
                local opts = { buffer = e.buf }

                vim.keymap.set("n", "gD", function()
                    vim.lsp.buf.declaration()
                end, { buffer = opts.buffer, desc = "Go to declaration" })

                vim.keymap.set("n", "<leader>gt", function()
                    vim.lsp.buf.type_definition()
                end, { buffer = opts.buffer, desc = "Go to type definition" })

                vim.keymap.set(
                    "n",
                    "gd",
                    require("telescope.builtin").lsp_definitions,
                    { desc = "Go to definition", buffer = opts.buffer }
                )

                vim.keymap.set(
                    "n",
                    "gI",
                    require("telescope.builtin").lsp_implementations,
                    { desc = "Go to implementations", buffer = opts.buffer }
                )

                vim.keymap.set("n", "K", function()
                    vim.lsp.buf.hover { border = "rounded" }
                end, { desc = "Show hover information", buffer = opts.buffer })

                vim.keymap.set(
                    "n",
                    "<leader>bs",
                    require("telescope.builtin").lsp_document_symbols,
                    { desc = "Search document symbols", buffer = opts.buffer }
                )

                vim.keymap.set(
                    "n",
                    "<leader>ws",
                    require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    { desc = "Search workspace symbols", buffer = opts.buffer }
                )

                vim.keymap.set({ "n", "x" }, "<leader>ca", function()
                    vim.lsp.buf.code_action()
                end, { desc = "Code action", buffer = opts.buffer })

                vim.keymap.set(
                    "n",
                    "<leader>gr",
                    require("telescope.builtin").lsp_references,
                    { desc = "List references", buffer = opts.buffer }
                )

                vim.keymap.set("n", "<leader>rn", function()
                    vim.lsp.buf.rename()
                end, { desc = "Rename symbol", buffer = opts.buffer })

                vim.keymap.set("n", "<F2>", function()
                    vim.lsp.buf.rename()
                end, { desc = "Rename symbol", buffer = opts.buffer })

                vim.keymap.set("i", "<C-h>", function()
                    vim.lsp.buf.signature_help()
                end, { desc = "Signature help", buffer = opts.buffer })
            end,
        })
    end,
}
