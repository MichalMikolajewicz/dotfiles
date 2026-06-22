# dotfiles

Personal configuration files.

## Requirements

- [Neovim](https://neovim.io/) >= 0.9
- [ripgrep](https://github.com/BurntSushi/ripgrep) — for Telescope live grep
- [fd](https://github.com/sharkdp/fd) — for Telescope file search
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

Available profiles:

| Profile | Description |
|---------|-------------|
| `full` (default) | Everything: C#, Rust |
| `csharp` | C# / .NET only, no Rust tooling |

## Structure

```
dotfiles/
├── nvim/                   symlinked to ~/.config/nvim
│   └── lua/
│       ├── config/
│       │   └── profile.lua reads ~/.config/nvim/.profile
│       └── plugins/
│           ├── telescope.lua   core — always loaded
│           ├── blink.lua       core — always loaded
│           ├── lualine.lua     core — always loaded
│           ├── tmux.lua        core — seamless <C-h/j/k/l> w/ tmux
│           ├── csharp.lua      csharp + full profiles
│           └── rust.lua        full profile only
├── tmux/                   symlinked to ~/.config/tmux
│   ├── tmux.conf
│   └── plugins/            TPM-managed (gitignored)
└── install.sh
```

## tmux first run

```bash
bash install.sh                                  # symlinks ~/.config/tmux
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
tmux                                             # then press  prefix + I  to install plugins
```

## Adding a new tool

1. Move its config into `~/dotfiles/<name>/`
2. Add a `link` line to `install.sh`
