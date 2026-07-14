-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- ~/.dotnet/tools must be in PATH for easy-dotnet's embedded Roslyn server.
-- /etc/paths.d on macOS adds it with a literal ~ that Neovim never expands;
-- Linux .profile-based additions don't reach non-interactive shells either.
-- Fixing it here makes the config self-contained on any OS / shell.
local dotnet_tools = vim.env.HOME .. "/.dotnet/tools"
if vim.fn.isdirectory(dotnet_tools) == 1 and not vim.env.PATH:find(dotnet_tools, 1, true) then
  vim.env.PATH = dotnet_tools .. ":" .. vim.env.PATH
end

-- Move the line-length guide out from the cramped 80-column convention.
vim.opt.colorcolumn = "160"

-- Disable LazyVim's format-on-save by default. On-save formatting (prettier via
-- conform.nvim) reflows whole files to its own tabWidth/printWidth and fights the
-- indent settings set above per filetype. Toggle back on per-buffer with <leader>uF
-- (or globally with <leader>uf); format once manually with <leader>cf.
vim.g.autoformat = false

-- No swap files. In a parallel-editing workflow (nvim + VS Code/Copilot) vim's .swp
-- "crash recovery" only ever surfaces as false-alarm "Swap file already exists / another
-- program is using it" prompts — from stale .swp left by killed nvim sessions, or from
-- VS Code's Neovim/vim extension writing its own .swp on the same file. Git is the real
-- safety net, and LazyVim already sets undofile=true for cross-session undo. swapfile=false
-- kills every swap prompt. (backup is already off; writebackup is a harmless temp file that's
-- auto-deleted after each write.)
vim.opt.swapfile = false
