--[[ Available themes:
  "folke/tokyonight.nvim" -> tokyonight-night
  "scottmckendry/cyberdream.nvim" -> cyberdream  
  "olimorris/onedarkpro.nvim" -> onedark
  "catppuccin/nvim" -> catppuccin-mocha
  "neanias/everforest-nvim" -> everforest
  "rebelot/kanagawa.nvim" -> kanagawa-wave
  "dasupradyumna/midnight.nvim" -> midnight
	"rebelot/kanagawa.nvim" -> kanagawa-wave
]]

return {
	"dasupradyumna/midnight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("colorscheme midnight")
	end,
}
