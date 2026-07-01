-- Snacks derives lazygit's selected-row color from the `Visual` highlight group
-- by default. Under gruvbox-material that bg (#45403d) is too close to Normal's
-- bg (#282828) to read as a selection, so give lazygit its own high-contrast
-- highlight instead of touching `Visual` (which is fine for normal editing).
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("snacks_lazygit_theme", { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, "SnacksLazygitSelectedLine", { bg = "#d8a657", fg = "#282828" })
  end,
})
vim.api.nvim_set_hl(0, "SnacksLazygitSelectedLine", { bg = "#d8a657", fg = "#282828" })

return {
  {
    "folke/snacks.nvim",
    opts = {
      image = { enabled = true },
      lazygit = {
        theme = {
          selectedLineBgColor = { bg = "SnacksLazygitSelectedLine" },
          selectedRangeBgColor = { bg = "SnacksLazygitSelectedLine" },
        },
      },
    },
  },
}
