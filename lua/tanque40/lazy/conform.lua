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
            },
            formatters = {
              -- Definimos un formateador custom para usar eslint_d en modo fix
              eslint_d_fix = {
                command = "eslint_d",
                args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
              },
            },
        })
    end,
}
