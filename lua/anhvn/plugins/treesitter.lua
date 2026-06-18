---@diagnostic disable: missing-fields
return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require "nvim-treesitter"

            local parser_ft = {
                angular = { "htmlangular" },
                bash = { "sh" },
                bibtex = { "bib" },
                c_sharp = { "cs", "csharp" },
                commonlisp = { "lisp" },
                cooklang = { "cook" },
                devicetree = { "dts" },
                diff = { "gitdiff" },
                eex = { "eelixir" },
                elixir = { "ex" },
                embedded_template = { "eruby" },
                erlang = { "erl" },
                facility = { "fsd" },
                faust = { "dsp" },
                gdshader = { "gdshaderinc" },
                git_config = { "gitconfig" },
                git_rebase = { "gitrebase" },
                glimmer = { "handlebars", "html.handlebars" },
                godot_resource = { "gdresource" },
                haskell = { "hs" },
                haskell_persistent = { "haskellpersistent" },
                idris = { "idris2" },
                ini = { "confini", "dosini" },
                janet_simple = { "janet" },
                javascript = { "javascriptreact", "ecma", "ecmascript", "jsx", "js" },
                json = { "jsonc" },
                glimmer_javascript = { "javascript.glimmer" },
                latex = { "tex" },
                linkerscript = { "ld" },
                m68k = { "asm68k" },
                make = { "automake" },
                markdown = { "pandoc" },
                muttrc = { "neomuttrc" },
                ocaml_interface = { "ocamlinterface" },
                perl = { "pl" },
                poe_filter = { "poefilter" },
                powershell = { "ps1" },
                properties = { "jproperties" },
                python = { "py", "gyp" },
                qmljs = { "qml" },
                runescript = { "clientscript" },
                scala = { "sbt" },
                slang = { "shaderslang" },
                ssh_config = { "sshconfig" },
                starlark = { "bzl" },
                surface = { "sface" },
                systemverilog = { "verilog" },
                t32 = { "trace32" },
                tcl = { "expect" },
                terraform = { "terraform-vars" },
                textproto = { "pbtxt" },
                tlaplus = { "tla" },
                tsx = { "typescriptreact", "typescript.tsx" },
                typescript = { "ts" },
                glimmer_typescript = { "typescript.glimmer" },
                typst = { "typ" },
                udev = { "udevrules" },
                uxntal = { "tal", "uxn" },
                v = { "vlang" },
                vhs = { "tape" },
                xml = { "xsd", "xslt", "svg" },
                xresources = { "xdefaults" },
            }

            for lang, fts in pairs(parser_ft) do
                for _, ft in ipairs(fts) do
                    vim.treesitter.language.register(lang, ft)
                end
            end

            ts.setup {
                -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
                install_dir = vim.fn.stdpath "data" .. "/site",
            }

            ts.install {
                "c",
                "cpp",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
                "yaml",
                "javascript",
                "typescript",
                "tsx",
                "go",
                "java",
                "rust",
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "*" },
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
    { "nvim-treesitter/nvim-treesitter-context", opts = {} },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        init = function()
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["ar"] = "@return.outer",
                        ["ir"] = "@return.inner",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>as"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>aS"] = "@parameter.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = false, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                    },
                },
            }
            -- selects
            vim.keymap.set({ "x", "o" }, "am", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "im", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ac", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ar", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@return.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ir", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@return.inner", "textobjects")
            end)

            -- swaps
            vim.keymap.set("n", "<leader>as", function()
                require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
            end)
            vim.keymap.set("n", "<leader>aS", function()
                require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
            end)

            -- moves
            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[m", function()
                require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[M", function()
                require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
            end)
        end,
    },
}
