return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
	lazy = false,
	config = function()
		CustomOilBar = function()
			local path = vim.fn.expand("%")
			path = path:gsub("oil://", "")

			return "  " .. vim.fn.fnamemodify(path, ":.")
		end

		require("oil").setup({
			columns = { "icon" },
			keymaps = {
				["<C-h>"] = false,
				["<C-l>"] = false,
				["<C-k>"] = false,
				["<C-j>"] = false,
				["<M-h>"] = "actions.select_split",
			},
			win_options = {
				winbar = "%{v:lua.CustomOilBar()}",
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
					return vim.tbl_contains(folder_skip, name)
				end,
			},
		})

		-- Open parent directory in floating window
		vim.keymap.set("n", "<leader>-", require("oil").toggle_float)
	end,
}
