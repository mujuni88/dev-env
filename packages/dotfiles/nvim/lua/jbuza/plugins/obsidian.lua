return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Buza/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Buza/**.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "Buza",
				path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Buza/",
			},
			{
				name = "Notion Archive",
				path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notion-Archive/",
			},
		},
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
		new_notes_location = "current_dir",
		note_id_func = function(title)
			return title
		end,
		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},
		templates = {
			subdir = "Templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			substitutions = {
				yesterday = function()
					return os.date("%Y-%m-%d", os.time() - 86400)
				end,
				tomorrow = function()
					return os.date("%Y-%m-%d", os.time() + 86400)
				end,
			},
		},
		ui = {
			enable = false,
		},
	},
	keys = {
		{ "<leader>oc", "<cmd>lua require('obsidian').util.toggle_checkbox()<cr>", desc = "Toggle checkbox" },
		{ "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Obsidian Template" },
		{ "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian App" },
		{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show ObsidianBacklinks" },
		{ "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Show ObsidianLinks" },
		{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Create New Note" },
		{ "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian" },
		{ "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
	},
}
