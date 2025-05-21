--[[ Available themes:
  "folke/tokyonight.nvim" -> tokyonight-night
  "scottmckendry/cyberdream.nvim" -> cyberdream  
  "olimorris/onedarkpro.nvim" -> onedark
  "catppuccin/nvim" -> catppuccin-mocha
  "sainnhe/everforest" -> everforest
  "rebelot/kanagawa.nvim" -> kanagawa-wave
  "dasupradyumna/midnight.nvim" -> midnight
]]

return {
	"sainnhe/everforest",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("colorscheme everforest")
	end,
}
