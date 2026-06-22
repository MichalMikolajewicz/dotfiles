-- Seamless <C-h/j/k/l> between neovim splits and tmux panes.
return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window Left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window Down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window Up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window Right" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Previous Split" },
    },
  },
  -- k9s as a floating terminal inside nvim (lazygit already on <leader>gg via Snacks)
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>9", function() require("snacks").terminal({ "k9s" }) end, desc = "k9s" },
    },
  },
}
