-- C# / .NET support via easy-dotnet.nvim
-- Prerequisites on a fresh machine: Neovim, dotnet SDK.
-- EasyDotnet global tool is auto-installed by the plugin on first use.
-- No Mason entries needed: Roslyn LSP and netcoredbg are both bundled in EasyDotnet.

local profile = require("config.profile")

return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    -- 'nvim-telescope/telescope.nvim' or 'ibhagwan/fzf-lua' or 'folke/snacks.nvim'
    -- are highly recommended for a better experience
    dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "folke/snacks.nvim" },
    config = function()
      local dotnet = require("easy-dotnet")
      -- Options are not required
      dotnet.setup({
        managed_terminal = {
          auto_hide = true, -- auto hides terminal if exit code is 0
          auto_hide_delay = 1000, -- delay before auto hiding, 0 = instant
          mappings = {
            next_tab = { lhs = "<Tab>", desc = "Next terminal tab" },
            prev_tab = { lhs = "<S-Tab>", desc = "Previous terminal tab" },
            new_terminal = { lhs = "+", desc = "New user terminal" },
            close_terminal = { lhs = "X", desc = "Close current terminal tab" },
            hide_panel = { lhs = "q", desc = "Hide terminal panel" },
          },
        },
        -- Optional configuration for external terminals (matches nvim-dap structure)
        external_terminal = nil,
        projx_lsp = {
          enabled = true,
        },
        lsp = {
          enabled = true, -- Enable builtin roslyn lsp
          set_fold_expr = false,
          preload_roslyn = true, -- Start loading roslyn before any buffer is opened
          roslynator_enabled = true, -- Automatically enable roslynator analyzer
          easy_dotnet_analyzer_enabled = true, -- Enable roslyn analyzer from easy-dotnet-server
          easy_dotnet_extension_enabled = false, -- Needs to be true for enhanced_rename and create_type_from_usage
          enhanced_rename = false, -- auto rename file when renaming class
          create_type_from_usage = false, -- code action for creating class from unresolved symbol in a separate file
          restart_roslyn_on_branch_change = false, -- Restart Roslyn when Git HEAD changes
          auto_refresh_codelens = true,
          suggest_updates = true, -- Periodically suggest roslyn-language-server updates
          analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
          razor = {
            enabled = true,
            html = {
              enabled = true,
              cmd = nil, -- Auto-detect project node_modules/.bin/vscode-html-language-server, then PATH
              request_timeout = 5000,
            },
          },
          config = {},
        },
        debugger = {
          -- Path to custom coreclr DAP adapter
          -- When set, this fully overrides `engine`; easy-dotnet-server uses this binary as-is.
          -- When nil, easy-dotnet-server falls back to its own bundled debugger selected by `engine`.
          bin_path = nil,
          -- Which bundled debugger to use when `bin_path` is nil.
          --   "netcoredbg" (default) — Samsung netcoredbg
          --   "dncdbg"               — viewizard/dncdbg (a fork of netcoredbg with a richer set of features)
          --   "sharpdbg"             — MattParkerDev/sharpdbg (a new debugger written in C#)
          engine = "netcoredbg",
          console = "integratedTerminal", -- Controls where the target app runs: "integratedTerminal" (Neovim buffer) or "externalTerminal" (OS window)
          apply_value_converters = true,
          auto_register_dap = true,
          mappings = {
            open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
          },
        },
        ---@type TestRunnerOptions
        test_runner = {
          auto_start_testrunner = true,
          hide_legend = false,
          -- Using neotest (test.lua) for tests: let it own the .cs buffer keymaps/signs so
          -- easy-dotnet's <leader>d/<leader>t/<leader>r/<leader>p buffer maps don't shadow dap
          -- and neotest, and signs don't duplicate. easy-dotnet's own runner still works via :Dotnet.
          neotest_integration = true,
          ---@type "split" | "vsplit" | "float" | "buf"
          viewmode = "float",
          ---@type number|nil
          vsplit_width = nil,
          ---@type string|nil "topleft" | "topright"
          vsplit_pos = nil,
          icons = {
            passed = "",
            skipped = "",
            failed = "",
            success = "",
            reload = "",
            test = "",
            sln = "󰘐",
            project = "󰘐",
            dir = "",
            package = "",
            class = "",
            build_failed = "󰒡",
          },
          mappings = {
            run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
            run_all_tests_from_buffer = { lhs = "<leader>t", desc = "Run all tests in file" },
            get_build_errors = { lhs = "<leader>e", desc = "get build errors" },
            peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "peek stack trace from buffer" },
            debug_test_from_buffer = { lhs = "<leader>d", desc = "run test from buffer" },
            debug_test = { lhs = "<leader>d", desc = "debug test" },
            go_to_file = { lhs = "<leader>g", desc = "go to file" },
            run_all = { lhs = "<leader>R", desc = "run all tests" },
            run = { lhs = "<leader>r", desc = "run test" },
            peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
            expand = { lhs = "o", desc = "expand" },
            expand_node = { lhs = "E", desc = "expand node" },
            collapse_all = { lhs = "W", desc = "collapse all" },
            close = { lhs = "q", desc = "close testrunner" },
            refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
            cancel = { lhs = "<C-c>", desc = "cancel in-flight operation" },
            next_failure = { lhs = "]f", desc = "jump to next failing test" },
            prev_failure = { lhs = "[f", desc = "jump to previous failing test" },
          },
        },
        new = {
          project = {
            prefix = "sln", -- "sln" | "none"
          },
        },
        csproj_mappings = true,
        fsproj_mappings = true,
        auto_bootstrap_namespace = {
          --block_scoped, file_scoped
          type = "block_scoped",
          enabled = true,
          use_clipboard_json = {
            behavior = "prompt", --'auto' | 'prompt' | 'never',
            register = "+", -- which register to check
          },
        },
        server = {
          use_visual_studio = false, -- Set true for .NET Framework support on Windows
          ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
          log_level = nil,
        },
        -- choose which picker to use with the plugin
        -- possible values are "telescope" | "fzf" | "snacks" | "basic"
        -- if no picker is specified, the plugin will determine
        -- the available one automatically with this priority:
        --  snacks -> fzf -> telescope ->  basic
        picker = "snacks",
        notifications = {
          --Set this to false if you have configured lualine to avoid double logging
          handler = function(start_event)
            local spinner = require("easy-dotnet.ui-modules.spinner").new()
            spinner:start_spinner(function()
              return start_event.job.name
            end)
            ---@param finished_event JobEvent
            return function(finished_event)
              spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
            end
          end,
        },
        diagnostics = {
          default_severity = "error",
          setqflist = false,
        },
        outdated = {
          mappings = {
            upgrade = { lhs = "<leader>pu", desc = "upgrade package under cursor" },
            upgrade_all = { lhs = "<leader>pa", desc = "upgrade all outdated packages" },
          },
        },
      })

      -- ── C# indentation: drop easy-dotnet's legacy GetCSIndent indentexpr ─────────────
      -- easy-dotnet forces nvim's GetCSIndent (runtime indent/cs.vim) as the indentexpr on
      -- every .cs buffer; it's an old heuristic that ignores .editorconfig and indents
      -- inconsistently (the "random indentation" madness). Clear it on LspAttach (runs after
      -- easy-dotnet's on_attach, so this wins) and use cindent, which honors expandtab /
      -- shiftwidth from .editorconfig for sane live auto-indent.
      -- NOTE: no format-on-save. Roslyn LSP format-on-save was tried but was slow and made
      -- unwanted edits, so it was removed. Format manually when wanted, e.g.
      -- `:lua vim.lsp.format()` (Roslyn) or wire up csharpier/dotnet-format via conform.
      local fmt_augroup = vim.api.nvim_create_augroup("easy_dotnet_format", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = fmt_augroup,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "easy_dotnet" then return end
          vim.bo[args.buf].indentexpr = ""
          vim.bo[args.buf].cindent = true
        end,
      })

      -- ── Diagnostics: drop stale snapshot on save (one file at a time) ───────────
      -- Fixes two C# annoyances: errors that only vanish after a rebuild, and the
      -- same error shown twice. Root cause: easy-dotnet's on-demand `:Dotnet
      -- diagnostics` writes into its OWN namespace ("easy-dotnet-diagnostics") — a
      -- workspace *snapshot* the live Roslyn LSP never clears, so it lingers and
      -- overlaps the LSP's live diagnostics (also why <leader>xx/Trouble looked
      -- flaky). The live LSP namespace is left untouched.
      --
      -- This is deliberately cheap and per-buffer — it does NOT re-analyze the
      -- project (Roslyn does that on its own schedule). It only drops the stale
      -- cached snapshot for the ONE file you just edited/saved, and only when that
      -- snapshot actually has something for it. If you never run `:Dotnet
      -- diagnostics`, snapshot_ns caches to `false` and the callback is a no-op.
      -- update_in_insert stays OFF so typing is lag-free; the live LSP already
      -- re-pulls on InsertLeave, so by the time you :w its diagnostics are fresh.
      local snapshot_ns ---@type number|false|nil
      local function clear_snapshot(buf)
        if snapshot_ns == nil then
          snapshot_ns = vim.api.nvim_get_namespaces()["easy-dotnet-diagnostics"] or false
        end
        if snapshot_ns and vim.diagnostic.get(buf, { namespace = snapshot_ns })[1] then
          vim.diagnostic.reset(snapshot_ns, buf)
        end
      end
      local diag_augroup = vim.api.nvim_create_augroup("easy_dotnet_diagnostics", { clear = true })
      vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
        group = diag_augroup,
        pattern = "*.cs",
        callback = function(args) clear_snapshot(args.buf) end,
      })

      -- Example command
      vim.api.nvim_create_user_command("Secrets", function()
        dotnet.secrets()
      end, {})

      -- Example keybinding
      vim.keymap.set("n", "<C-p>", function()
        vim.cmd("Dotnet run profile default")
      end)
    end,
  },
}
