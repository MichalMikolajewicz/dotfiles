return {
  -- Lualine statusline with easy-dotnet job indicator
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      -- Add easy-dotnet job indicator to lualine
      local job_indicator = { require("easy-dotnet.ui-modules.jobs").lualine }

      -- Ensure sections table exists
      opts.sections = opts.sections or {}
      opts.sections.lualine_a = opts.sections.lualine_a or {}

      -- Add job indicator to the left side (lualine_a)
      table.insert(opts.sections.lualine_a, job_indicator)

      return opts
    end,
  },
}
