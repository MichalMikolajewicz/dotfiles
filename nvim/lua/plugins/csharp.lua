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
      -- Silence the known Roslyn "-30099 failed to get language for textDocument/diagnostic"
      -- spam (https://github.com/dotnet/roslyn/issues/81410): pull diagnostics fail on
      -- not-fully-loaded docs and nvim surfaces every error. Drop just that error;
      -- push diagnostics (and everything else) are unaffected.
      local orig = vim.lsp.handlers["textDocument/diagnostic"]
      vim.lsp.handlers["textDocument/diagnostic"] = function(err, result, ctx, cfg)
        if err and (err.message or ""):lower():find("failed to get language") then
          return
        end
        return orig and orig(err, result, ctx, cfg)
      end

      require("easy-dotnet").setup({
        lsp = {
          enabled = true,
          roslynator_enabled = true,
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

      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
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
