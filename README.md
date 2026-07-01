# dotfiles

Personal configuration files.

## Requirements

- [Neovim](https://neovim.io/) >= 0.9
- [ripgrep](https://github.com/BurntSushi/ripgrep) — for live grep (snacks.picker)
- [fd](https://github.com/sharkdp/fd) — optional, faster file finding (snacks.picker)
- [tmux](https://github.com/tmux/tmux) — splits + seamless `<C-h/j/k/l>` nav across nvim and panes
- git

Optional (for the split workflow):
- [lazygit](https://github.com/jesseduffield/lazygit) — `<leader>gg` (nvim) or `prefix + g` (tmux)
- [k9s](https://github.com/derailed/k9s) — `<leader>9` (nvim floating terminal)

C# profile additionally requires:
- [.NET SDK](https://dotnet.microsoft.com/download)

## Install

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
bash install.sh [profile]
```

If `git clone` is blocked (some proxies/devpods allow plain HTTPS but not git's
smart-http protocol), grab a tarball instead — no `.git`, so `git pull` won't
work later, but it's enough to run `install.sh`:

```bash
curl -fsSL https://codeload.github.com/MichalMikolajewicz/dotfiles/tar.gz/HEAD -o /tmp/dotfiles.tar.gz
mkdir -p ~/dotfiles && tar -xzf /tmp/dotfiles.tar.gz -C ~/dotfiles --strip-components=1
cd ~/dotfiles
bash install.sh [profile]
```

Available profiles:

| Profile | Description |
|---------|-------------|
| `full` (default) | C# / .NET tooling enabled |
| `csharp` | same as `full` (C# / .NET) |

## Structure

```
dotfiles/
├── nvim/                   symlinked to ~/.config/nvim
│   └── lua/
│       ├── config/
│       │   └── profile.lua reads ~/.config/nvim/.profile
│       └── plugins/
│           ├── colorscheme.lua catppuccin frappe (matches Ghostty/tmux)
│           ├── blink.lua       completion — always loaded
│           ├── lualine.lua     statusline — always loaded
│           ├── tmux.lua        seamless <C-h/j/k/l> w/ tmux + k9s terminal
│           ├── test.lua        neotest (C# + Vitest)
│           └── csharp.lua      C#/.NET (easy-dotnet) — csharp + full profiles
├── tmux/                   symlinked to ~/.config/tmux
│   ├── tmux.conf
│   └── plugins/            TPM-managed (gitignored)
└── install.sh
```

## tmux

`install.sh` also fetches the tmux plugins (TPM + everything in `tmux.conf`),
so seamless `<C-h/j/k/l>` between nvim and tmux panes, the catppuccin status
bar, etc. work on the first launch with no extra steps.

To update plugins later, use `prefix + U` inside tmux (TPM is installed for this).


## Adding a new tool

1. Move its config into `~/dotfiles/<name>/`
2. Add a `link` line to `install.sh`
