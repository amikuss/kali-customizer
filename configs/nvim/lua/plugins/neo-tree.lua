return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- optional but nice
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree", -- lazy-load on :Neotree command
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Neo-tree toggle" },
		-- add more if you want
	},
	opts = {
		filesystem = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
				hijack_netrw_behavior = "open_current",
			},
			bind_to_cwd = true,
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
			},
		},
		close_if_last_window = true,
		enable_git_status = true,
		window = {
			position = "left",
			width = 30,
		},
	},
	init = function()
		-- This runs early — before lazy actually loads neo-tree
		vim.api.nvim_create_autocmd("VimEnter", {
			once = true, -- only need to run once
			nested = false,
			callback = function()
				-- Make sure neo-tree is loaded when we need it
				require("lazy").load({ plugins = { "neo-tree.nvim" } })

				vim.schedule(function()
					local arg = vim.fn.argv(0) -- first argument

					if arg == nil or arg == "" then
						-- no argument → just open neo-tree in current dir
						vim.cmd("Neotree focus")
					elseif vim.fn.isdirectory(arg) == 1 then
						vim.cmd.cd(arg)
						vim.cmd("Neotree focus")
						vim.cmd("wincmd p")
						local buf = vim.api.nvim_get_current_buf()
						if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == "" then
							vim.api.nvim_buf_delete(buf, { force = true })
						end

						-- Return focus to neo-tree
						vim.cmd("wincmd p")
					end
				end)
			end,
		})
	end,
}
