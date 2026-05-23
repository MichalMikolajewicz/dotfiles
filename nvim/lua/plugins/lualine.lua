local profile = require("config.profile")

return {
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      if not profile.has("csharp") then
        return opts
      end

      local job_indicator = { require("easy-dotnet.ui-modules.jobs").lualine }
      opts.sections = opts.sections or {}
      opts.sections.lualine_a = opts.sections.lualine_a or {}
      table.insert(opts.sections.lualine_a, job_indicator)

      return opts
    end,
  },
}
