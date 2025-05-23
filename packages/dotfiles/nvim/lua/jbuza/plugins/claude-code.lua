return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for git operations
	},
	config = function()
		require("claude-code").setup({
			keymaps = {
				toggle = {
					normal = "<C-,>", -- Normal mode keymap for toggling Claude Code, false to disable
					terminal = "<C-,>", -- Terminal mode keymap for toggling Claude Code, false to disable
					variants = {
						continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
						verbose = "<leader>cV", -- Normal mode keymap for Claude Code with verbose flag
					},
				},
			},
		})
	end,
}
