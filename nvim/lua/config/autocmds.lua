-- Autocmds are automatically loaded on the VeryLazy event.
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Over SSH, mirror yanks to the host clipboard via OSC52 — so text yanked in nvim is
-- pasteable in the SSH client's OS (e.g. Windows Terminal → Windows clipboard).
-- macOS already uses pbcopy, so this runs only inside SSH sessions. The whole thing is
-- wrapped in pcall so it can never throw, no matter the machine.
if vim.env.SSH_CONNECTION or vim.env.SSH_TTY then
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      if vim.v.event.operator ~= "y" then
        return
      end
      pcall(function()
        local tty = io.open("/dev/tty", "w")
        if tty then
          tty:write(("\27]52;c;%s\7"):format(vim.base64.encode(table.concat(vim.v.event.regcontents, "\n"))))
          tty:close()
        end
      end)
    end,
  })
end
