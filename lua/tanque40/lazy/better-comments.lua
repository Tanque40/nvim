return {
  "Djancyp/better-comments.nvim",
  config = function ()
    require('better-comment').Setup({
      tags = {
        {
          name = "*",
          fg = "#20f518",
          bg = "",
          bold = true,
          virtual_text = "",
        },
        {
          name = "?",
          fg = "#20f5ff",
          bg = "",
          bold = true,
          virtual_text = "🤔",
        },
        {
          name = "TODO",
          fg = "#ff9812",
          bg = "",
          bold = false,
          virtual_text = "",
        }

      }
    })
  end
}
