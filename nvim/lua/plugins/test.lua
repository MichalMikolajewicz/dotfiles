-- In-editor test runner. LazyVim's `test.core` extra (enabled in lazyvim.json)
-- provides neotest core + the <leader>t keymaps (tt nearest, tf file, to output,
-- ts summary, tS stop). Here we only register the language adapters.
--
--   neotest-vitest  → JS/TS (Vite/Vitest projects)
--   neotest-dotnet  → C#/.NET, gated on the csharp profile; its `dap` opt lets
--                     <leader>td hand a test to nvim-dap (netcoredbg is
--                     auto-registered by easy-dotnet).
local profile = require("config.profile")

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
      {
        "Issafalcon/neotest-dotnet",
        enabled = function() return profile.has("csharp") end,
      },
    },
    opts = function()
      local adapters = {
        require("neotest-vitest")({}),
      }
      if profile.has("csharp") then
        table.insert(adapters, require("neotest-dotnet")({ dap = { justMyCode = false } }))
      end
      return { adapters = adapters }
    end,
  },
}
