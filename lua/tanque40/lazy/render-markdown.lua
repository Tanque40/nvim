return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- Shortcuts solo en buffers de markdown
    keys = {
        -- Activar/desactivar el renderizado
        { "<leader>mr", "<cmd>RenderMarkdown buf_toggle<CR>", ft = "markdown", desc = "Markdown: toggle render" },
        -- Vista previa en una ventana lateral
        { "<leader>mp", "<cmd>RenderMarkdown preview<CR>", ft = "markdown", desc = "Markdown: preview" },
    },
    config = function()
        require("render-markdown").setup({
            -- Renderiza en modo normal y comando; en insert muestra el texto crudo
            render_modes = { "n", "c" },

            -- Muestra el texto original de la línea donde está el cursor
            anti_conceal = {
                enabled = true,
            },

            heading = {
                -- Iconos para # ## ### ...
                icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                width = "full",
            },

            code = {
                -- Muestra el lenguaje y un fondo en los bloques de código
                style = "full",
                width = "block",
                left_pad = 2,
                right_pad = 2,
            },

            checkbox = {
                enabled = true,
            },
        })
    end
}
