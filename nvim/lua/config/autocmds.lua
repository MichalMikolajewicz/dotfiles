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

-- LazyVim defaults shiftwidth/tabstop to 2 everywhere; web/node ecosystems (JS, TS,
-- JSX/TSX, HTML, CSS, Vue, Svelte...) conventionally use 4. Override per-filetype
-- rather than changing the global default.
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "html",
    "css",
    "scss",
    "less",
    "json",
    "jsonc",
    "vue",
    "svelte",
  },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
  end,
})

-- Pin format-on-save OFF for yaml + js/ts. LazyVim's format-on-save (BufWritePre →
-- LazyVim.format) checks `vim.b.autoformat` first (buffer-local wins over `vim.g.autoformat`),
-- so a buffer-local false here survives `<leader>uf` flipping the GLOBAL toggle on for other
-- languages. Explicit formatting still works: `<leader>cf` / `:LazyFormat` call format() with
-- force=true, which bypasses the enabled() check entirely. Global autoformat is already false
-- (options.lua); this just makes the guarantee explicit per-filetype.
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "yaml",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Auto-reload buffers changed on disk (e.g. VS Code/Copilot saved the file you also have open
-- in nvim). autoread is on by default, but nvim only re-checks the file on a few events, so
-- without this you can still land on a stale buffer or get a "file changed since reading it"
-- nudge. checktime on focus / buffer-enter / cursor-idle makes autoread pick up the external
-- write immediately. Pairs with swapfile=false (options.lua) for conflict-free parallel editing.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "silent! checktime",
  group = vim.api.nvim_create_augroup("autochecktime", { clear = true }),
})
