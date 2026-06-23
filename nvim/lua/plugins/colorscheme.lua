-- Catppuccin Frappe, to match the Ghostty + tmux colour scheme — one unified
-- palette across the whole Ghostty → tmux → nvim stack. catppuccin is already
-- pinned in lazy-lock.json, so this just selects it and locks the Frappe flavour.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "frappe",
    },
  },
  -- tell LazyVim to apply catppuccin as the default colorscheme
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
