-- C# / .NET support via easy-dotnet.nvim
-- Prerequisites on a fresh machine: Neovim, dotnet SDK.
-- EasyDotnet global tool is auto-installed by the plugin on first use.
-- No Mason entries needed: Roslyn LSP and netcoredbg are both bundled in EasyDotnet.

local profile = require("config.profile")

return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    enabled = function() return profile.has("csharp") end,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
    ft = { "cs", "csproj", "sln", "fsproj" },
    config = function()
      require("easy-dotnet").setup({
        lsp = {
          enabled = true,
          set_fold_expr = true,
          -- Preload Roslyn so it has the project loaded before nvim starts sending
          -- requests. Without this, the cold-start race produces "-30099 failed to get
          -- language" on documentHighlight/diagnostic.
          preload_roslyn = true,
          roslynator_enabled = true,
          easy_dotnet_analyzer_enabled = true,
          auto_refresh_codelens = true,
          analyzer_assemblies = {},
          config = {
            settings = {
              ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_enable_inlay_hints_for_parameters = true,
                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
              },
              ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
              },
            },
          },
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
