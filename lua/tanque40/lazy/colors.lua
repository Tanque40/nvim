function ColorMyPencils(color)
	color = color or "kanagawa-dragon"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
	vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
end

return {
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		config = function()
			ColorMyPencils()
		end
	}
}
