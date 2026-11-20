return {
    {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- la rama main no soporta lazy-loading
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")

        -- Parsers que siempre deben estar instalados (requiere `tree-sitter` CLI)
        ts.install({
            "vimdoc", "javascript", "typescript", "c", "lua", "rust",
            "jsdoc", "bash", "templ", "markdown", "markdown_inline",
        })

        local max_filesize = 100 * 1024 -- 100 KB

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("tanque40_treesitter", { clear = true }),
            callback = function(args)
                local buf = args.buf
                local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
                if not lang or lang == "html" then
                    return
                end

                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    vim.notify(
                        "File larger than 100KB treesitter disabled for performance",
                        vim.log.levels.WARN,
                        { title = "Treesitter" }
                    )
                    return
                end

                -- Equivalente a `auto_install = true`
                if not vim.list_contains(ts.get_installed("parsers"), lang) then
                    if vim.list_contains(ts.get_available(), lang) then
                        ts.install(lang):await(vim.schedule_wrap(function()
                            if vim.api.nvim_buf_is_valid(buf) then
                                pcall(vim.treesitter.start, buf, lang)
                            end
                        end))
                    end
                    return
                end

                if not pcall(vim.treesitter.start, buf, lang) then
                    return
                end

                -- additional_vim_regex_highlighting para markdown
                if lang == "markdown" then
                    vim.bo[buf].syntax = "on"
                end

                -- indent = { enable = true }
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require'treesitter-context'.setup{
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                multiwindow = false, -- Enable multiwindow support.
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to show for a single context
                trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20, -- The Z-index of the context window
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            }
        end
    }
}
