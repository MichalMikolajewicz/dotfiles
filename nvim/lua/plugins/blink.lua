local profile = require("config.profile")

local sources_default = { "lsp", "path", "snippets", "buffer" }
local sources_providers = {}

if profile.has("csharp") then
  table.insert(sources_default, "easy-dotnet")
  sources_providers["easy-dotnet"] = {
    name = "easy-dotnet",
    enabled = true,
    module = "easy-dotnet.completion.blink",
    score_offset = 10000,
    async = true,
  }
end

return {
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "saghen/blink.compat",
    },
    opts = {
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
      sources = {
        default = sources_default,
        providers = sources_providers,
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      signature = {
        enabled = true,
      },
    },
  },
}
