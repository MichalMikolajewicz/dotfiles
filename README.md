# dotfiles

Personal configuration files.

## Requirements

- [Neovim](https://neovim.io/) >= 0.9
- [ripgrep](https://github.com/BurntSushi/ripgrep) — for Telescope live grep
- [fd](https://github.com/sharkdp/fd) — for Telescope file search
- git

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
│           ├── csharp.lua      csharp + full profiles
│           └── rust.lua        full profile only
└── install.sh
```

## Adding a new tool

1. Move its config into `~/dotfiles/<name>/`
2. Add a `link` line to `install.sh`
