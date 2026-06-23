-- Git diff / history / merge UI via diffview.nvim.
-- Complements gitsigns + lazygit (<leader>gg): diffview gives a full split-diff
-- view of the working tree or any git rev, branch/file history, and a 3-way
-- merge-conflict resolver.
-- Pure Lua; the only external CLI it touches is git (already required by the
-- rest of the git workflow). Lazy-loads on first diff command or key.

return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Diffview: Open" },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview: File History" },
    },
    opts = {},
  },
}
