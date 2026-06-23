-- C# / .NET support via easy-dotnet.nvim
-- Prerequisites on a fresh machine: Neovim, dotnet SDK.
-- EasyDotnet global tool is auto-installed by the plugin on first use.
-- No Mason entries needed: Roslyn LSP and netcoredbg are both bundled in EasyDotnet.

local profile = require("config.profile")

return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    enabled = function() return profile.has("csharp") end,
    dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
    ft = { "cs", "csproj", "sln", "fsproj" },
    config = function()
      require("easy-dotnet").setup({
        -- use the same snacks picker as the rest of the config (no telescope)
        picker = "snacks",
        lsp = {
          enabled = true,
          set_fold_expr = true,
          -- Start loading Roslyn before any buffer opens (snappier first edit).
          preload_roslyn = true,
          roslynator_enabled = true,
          easy_dotnet_analyzer_enabled = true,
          auto_refresh_codelens = true,
          analyzer_assemblies = {},
          -- NOTE: do NOT put LSP `settings` (or on_init) here — easy-dotnet's docs say
          -- settings belong in lsp/easy_dotnet.lua. Setting `config` here overrides
          -- easy-dotnet's internal server definition, which is what carries solution
          -- detection → Roslyn runs with no project → streaming "-30099 failed to get
          -- language".
        },
        debugger = { auto_register_dap = true },
        test_runner = { viewmode = "float" },
      })
      -- dapui setup + auto-open/close listeners live in plugins/dap.lua.
    end,
  },

  -- C# treesitter grammar
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = function() return profile.has("csharp") end,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "c_sharp" })
    end,
  },
}
