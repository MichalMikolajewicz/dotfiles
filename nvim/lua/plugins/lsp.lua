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
    },
  },
}
