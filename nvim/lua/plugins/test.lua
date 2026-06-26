-- In-editor test runner. LazyVim's `test.core` extra (enabled in lazyvim.json)
-- provides neotest core + the <leader>t keymaps (tt nearest, tf file, to output,
-- ts summary, tS stop). Here we only register the language adapters.
--
--   neotest-vitest → JS/TS (Vite/Vitest projects)
--
-- C#/.NET tests are run via `dotnet test` on the command line; neotest-dotnet
-- is omitted (Issafalcon/neotest-dotnet has a nil-context crash in results()).

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    opts = function()
      return {
        adapters = { require("neotest-vitest")({}) },
        watch = { enabled = false },
      }
    end,
  },
}
