--[[ Available themes:
  "folke/tokyonight.nvim" -> tokyonight-night
  "scottmckendry/cyberdream.nvim" -> cyberdream  
  "olimorris/onedarkpro.nvim" -> onedark
  "catppuccin/nvim" -> catppuccin-mocha
  "neanias/everforest-nvim" -> everforest
  "rebelot/kanagawa.nvim" -> kanagawa-wave
]]

return {
	"rebelot/kanagawa.nvim",
	version = false,
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("colorscheme kanagawa-wave")
	end,
}
