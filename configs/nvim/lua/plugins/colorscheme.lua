return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false, -- important: colorscheme should load immediately
	priority = 1000, -- load before other start plugins
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- or latte, frappe, macchiato, mocha
			-- transparent_background = true, etc.
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
