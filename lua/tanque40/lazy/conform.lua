return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier", "eslint_d_fix" }, -- Corre prettier y luego eslint fix
                typescript = { "prettier", "eslint_d_fix" },
                vue = { "prettier", "eslint_d_fix" }, -- Nuxt
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                rust = { "rustfmt" },
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
            -- Formatea al guardar; si no hay formateador usa el del LSP
            format_on_save = {
                timeout_ms = 1000,
                lsp_format = "fallback",
            },
            formatters = {
              -- Definimos un formateador custom para usar eslint_d en modo fix
              eslint_d_fix = {
                command = "eslint_d",
                args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
              },
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            conform.format({ async = true, lsp_format = "fallback" })
        end, { desc = "Formatear archivo o selección" })
    end,
}
