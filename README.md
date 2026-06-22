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

## tmux

`install.sh` also fetches the tmux plugins (TPM + everything in `tmux.conf`),
so seamless `<C-h/j/k/l>` between nvim and tmux panes, the catppuccin status
bar, etc. work on the first launch with no extra steps.

To update plugins later, use `prefix + U` inside tmux (TPM is installed for this).


## Adding a new tool

1. Move its config into `~/dotfiles/<name>/`
2. Add a `link` line to `install.sh`
