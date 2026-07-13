-- LSP overrides on top of LazyVim defaults.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Diagnostics display: full message on virtual lines under the cursor line; the truncated
      -- inline one-liner (virtual_text) OFF. WHY: LazyVim's default virtual_text squeezes each
      -- error onto ONE line after the code — unreadable for verbose C#/Roslyn messages, e.g.
      --   CS1061: 'string' does not contain a definition for 'Foo' and no extension method
      --   'Foo' accepting a first argument of type 'string' could be found (missing a using?)
      -- virtual_lines wraps the whole message; current_line=true expands ONLY the line under the
      -- cursor so a multi-error file doesn't shove your code around — walk the list with ]e/[e
      -- (next/prev ERROR, LazyVim default) and each expands as you land. Native nvim 0.11+ → no
      -- plugin (lsp_lines.nvim not needed). Calm-off: <leader>ud hides all diagnostics. Browsing
      -- many: <leader>xX (Trouble workspace). This deep-merges LazyVim's signs/underline/severity_sort.
      diagnostics = {
        virtual_text = false,
        virtual_lines = { current_line = true },
      },
      inlay_hints = {
        -- C# only: Roslyn (via easy-dotnet) floods .cs buffers with type + parameter-name
        -- inlay hints, making real formatting hard to read. Keep them on everywhere else.
        -- `exclude` fully replaces LazyVim's default list (no opts_extend), so re-list "vue".
        exclude = { "vue", "cs" },
      },
      servers = {
        -- Standalone .html files: event/attribute completion (e.g. `<button on` →
        -- onclick / onmouseover). These are lowercase HTML attributes, distinct from
        -- React's camelCase on* props (those come from vtsls in .tsx). Listing the server
        -- here is sufficient — LazyVim passes opts.servers to mason-lspconfig, which
        -- auto-installs html-lsp (a Node package) and enables it. No separate ensure_installed.
        html = {},
      },
    },
  },
}
