-- Colorschemes. Only one is active at a time (set `active`); the rest stay installed so you
-- can compare live, e.g. `:colorscheme gruvbox-material` / `:colorscheme gruvbox` /
-- `:colorscheme catppuccin-frappe`. Currently on gruvbox-material (softer/desaturated
-- palette) vs the regular gruvbox below.
local active = "gruvbox-material"

return {
  -- gruvbox-material (sainnhe) — current pick. Softer + more desaturated than regular
  -- gruvbox. Configured via g: vars, set in `init` so they're live before the colorscheme
  -- is applied. foreground: "material"=soft, "mix", "original"=vivid (close to morhetz).
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    init = function()
      -- background: soft|medium|hard ; foreground: material(soft)|mix|original(vivid).
      -- Italic comments are on by default; set gruvbox_material_disable_italic_comment=1 to off.
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_foreground = "material"
      -- Diagnostic virtual-text: grey(default)=comment-colored & indistinguishable from
      -- comments; colored=error red, warn yellow, info blue, hint purple (signs already red).
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
    end,
  },

  -- gruvbox (regular ellisonleao port) — kept installed for comparison (:colorscheme gruvbox)
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- `contrast` tunes the dark background: "" = medium (#282828, the iconic gruvbox
      -- dark), "hard" = darker (#1d2021), "soft" = lighter (#32302f).
      italic = {
        strings = false, -- keep C# string literals upright for readability
        comments = true,
        emphasis = true,
        folds = true,
      },
      transparent_mode = false,
    },
  },

  -- catppuccin (previous default) — kept installed for side-by-side comparison
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = { flavour = "frappe" },
  },

  -- tell LazyVim which colorscheme to apply at startup
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = active },
  },
}
