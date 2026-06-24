return {
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "saghen/blink.compat",
    },
    opts = {
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        -- easy-dotnet package/version completion (PackageReference in .csproj) is provided by
        -- its ProjX LSP (enabled by default) through the normal "lsp" source — .csproj is
        -- filetype "xml", which ProjX attaches to. The old "easy-dotnet" blink provider is
        -- deprecated and was removed (it triggered the `:checkhealth easy-dotnet`
        -- "cmp source configured, use projx_lsp instead" warning). See easy-dotnet news.md.
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      signature = {
        enabled = true,
      },
    },
  },
}
