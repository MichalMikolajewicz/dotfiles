return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- parsers used by Snacks.image (latex for math, css/scss for style blocks)
      ensure_installed = { "css", "latex", "scss" },
    },
  },
}
