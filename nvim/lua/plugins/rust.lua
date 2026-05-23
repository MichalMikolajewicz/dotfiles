local profile = require("config.profile")

return {
  {
    "neovim/nvim-lspconfig",
    enabled = function() return profile.has("rust") end,
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
      },
    },
  },
  {
    "simrat39/rust-tools.nvim",
    enabled = function() return profile.has("rust") end,
    opts = {
      tools = {
        hover_actions = {
          auto_focus = true,
        },
      },
    },
  },
}
