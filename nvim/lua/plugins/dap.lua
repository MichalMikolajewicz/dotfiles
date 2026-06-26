-- Debugging via nvim-dap + nvim-dap-ui.
-- Lazy-loads on the first debug key (F-keys or <leader>d...).
-- Breakpoint signs use Nerd Font glyphs (assumes a Nerd Font is set as the
-- terminal/guifont). Adapters are registered per-language elsewhere (e.g.
-- easy-dotnet auto-registers netcoredbg for C#).

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text", -- inline variable values while debugging
      "nvim-neotest/nvim-nio", -- required by dap-ui for its async UI
    },
    keys = {
      { "<leader>d", "", desc = "+debug" },
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        desc = "Debug: Breakpoint Condition",
      },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Debug: Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- Auto-open/close the UI around a session.
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Gutter signs (Nerd Font).
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpointRejected" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })
      -- Override highlight colors (dap-ui defaults are often colorless).
      vim.api.nvim_set_hl(0, "DapBreakpoint",          { fg = "#e51400" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f5a623" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected",  { fg = "#888888" })
      vim.api.nvim_set_hl(0, "DapLogPoint",            { fg = "#61afef" })
    end,
  },

  -- Inline variable values while debugging. Its own spec so lazy loads + configures it
  -- as a nvim-dap dependency — never require it from another plugin's config (that's what
  -- crashed before the plugin was fetched).
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
}
