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
