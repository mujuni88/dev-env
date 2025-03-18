return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      view = {
        width = 35,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
    
    -- Quick toggle between tree and buffer
    keymap.set("n", "<leader>e<leader>", function()
      local nvim_tree_view = require("nvim-tree.view")
      if nvim_tree_view.is_visible() then
        if vim.api.nvim_get_current_win() == nvim_tree_view.get_win_id() then
          -- If we're in the tree, move to the next window
          vim.cmd("wincmd l")
        else
          -- If we're in a buffer, focus the tree
          require("nvim-tree.api").tree.focus()
        end
      else
        -- If tree is not visible, open it
        require("nvim-tree.api").tree.toggle()
      end
    end, { desc = "Toggle between tree and buffer" })

    -- Window navigation keymaps (these will work in any window including nvim-tree)
    keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
    keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })
    keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate to window below" })
    keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate to window above" })
  end,
}
