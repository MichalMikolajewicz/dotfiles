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
          -- Preload Roslyn so it has the project loaded before nvim starts sending
          -- requests. Without this, the cold-start race produces "-30099 failed to get
          -- language" on documentHighlight/diagnostic.
          preload_roslyn = true,
          roslynator_enabled = true,
          easy_dotnet_analyzer_enabled = true,
          auto_refresh_codelens = true,
          analyzer_assemblies = {},
          config = {
            on_init = function(client)
              -- Disable pull diagnostics. nvim 0.11+ enables them by default, but Roslyn
              -- rejects textDocument/diagnostic during cold start with -30099 "failed to get
              -- language" (https://github.com/dotnet/roslyn/issues/81410). Push diagnostics
              -- (publishDiagnostics) still flow, so squiggles/inline diagnostics are intact —
              -- preload_roslyn (above) shrinks the cold-start window; this removes the
              -- remaining -30099 source outright.
              client.server_capabilities.diagnosticProvider = false
            end,
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
