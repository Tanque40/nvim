return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "rafamadriz/friendly-snippets",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()

        -- Config que aplica a todos los servidores
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                    }
                }
            }
        })

        vim.lsp.config("rust_analyzer", {
            settings = {
                ["rust-analyzer"] = {
                    -- Usa clippy para los diagnósticos al guardar
                    check = { command = "clippy" },
                    cargo = { allFeatures = true },
                    inlayHints = {
                        parameterHints = { enable = true },
                        typeHints = { enable = true },
                    },
                },
            },
        })

        vim.lsp.config("zls", {
            root_markers = { ".git", "build.zig", "zls.json" },
            settings = {
                zls = {
                    enable_inlay_hints = true,
                    enable_snippets = true,
                    warn_style = true,
                },
            },
        })
        vim.g.zig_fmt_parse_errors = 0
        vim.g.zig_fmt_autosave = 0

        -- clangd viene con Xcode (/usr/bin/clangd), no con Mason
        vim.lsp.config("clangd", {
            cmd = {
                "clangd",
                "--background-index", -- indexa todo el proyecto para autocompletar tu código
                "--clang-tidy", -- análisis de código adicional
                "--header-insertion=iwyu", -- agrega #include al autocompletar
                "--completion-style=detailed",
                "--function-arg-placeholders=true",
            },
        })
        vim.lsp.enable("clangd")

        -- Herramientas que no son LSP (formateadores) instaladas con Mason
        local registry = require("mason-registry")
        registry.refresh(function()
            for _, tool in ipairs({ "clang-format" }) do
                local ok, pkg = pcall(registry.get_package, tool)
                if ok and not pkg:is_installed() then
                    pkg:install()
                end
            end
        end)

        -- mason-lspconfig v2 activa solo (vim.lsp.enable) los servidores instalados
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
            },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("tanque40_lsp", { clear = true }),
            callback = function(args)
                local opts = { buffer = args.buf }
                -- El resto ya viene por defecto en nvim: K, grn, gra, grr, gri, gO
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

                local client = vim.lsp.get_client_by_id(args.data.client_id)

                -- Alternar entre .cpp y .h
                if client and client.name == "clangd" then
                    vim.keymap.set("n", "<leader>h", "<cmd>LspClangdSwitchSourceHeader<CR>",
                        { buffer = args.buf, desc = "C/C++: alternar source/header" })
                end

                -- Inlay hints (tipos inferidos) si el servidor los soporta
                if client and client:supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                end
            end,
        })

        local luasnip = require("luasnip")
        -- Carga los snippets de friendly-snippets (Rust, Lua, JS, etc.)
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Saltar entre los huecos de un snippet
        vim.keymap.set({ "i", "s" }, "<C-l>", function()
            if luasnip.jumpable(1) then luasnip.jump(1) end
        end, { silent = true, desc = "Snippet: siguiente hueco" })
        vim.keymap.set({ "i", "s" }, "<C-h>", function()
            if luasnip.jumpable(-1) then luasnip.jump(-1) end
        end, { silent = true, desc = "Snippet: hueco anterior" })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-w>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-s>'] = cmp.mapping.select_next_item(cmp_select),
                ['<Enter>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        })
    end
}
