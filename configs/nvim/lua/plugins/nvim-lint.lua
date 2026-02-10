return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			markdown = { "markdownlint" },
			javascript = { "eslint_d" },
			python = { "ruff", "pylint" },
			html = { "htmlint" },
			lua = { "luacheck" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
		}

		vim.diagnostic.config({
			virtual_text = true, -- shows the message inline
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
