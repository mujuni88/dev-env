--[[ Available themes:
  "folke/tokyonight.nvim" -> tokyonight-night
  "scottmckendry/cyberdream.nvim" -> cyberdream
  "olimorris/onedarkpro.nvim" -> onedark
  "catppuccin/nvim" -> catppuccin-mocha
  "sainnhe/everforest" -> everforest
  "rebelot/kanagawa.nvim" -> kanagawa-wave
  "dasupradyumna/midnight.nvim" -> midnight
  "ellisonleao/gruvbox.nvim" -> gruvbox
]]

return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			transparent_mode = false,
		})
		vim.cmd("colorscheme gruvbox")
	end,
}
