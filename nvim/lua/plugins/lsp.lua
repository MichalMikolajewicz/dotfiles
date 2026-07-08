-- LSP overrides on top of LazyVim defaults.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
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
