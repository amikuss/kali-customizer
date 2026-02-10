return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	event = "VeryLazy", -- or "User VeryLazy" if you use kickstart style
	opts = {}, -- calls require("hardtime").setup(opts) automatically
}
