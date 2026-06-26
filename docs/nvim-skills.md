# nvim skills (for this setup)

LazyVim already ships most of the power-user tooling — these are the keys and
techniques worth learning, all confirmed present in this config.

## Find & replace

| Goal | How |
|---|---|
| **Across the whole project (the easy way)** | `<leader>sr` → opens **grug-far**: type the search text and the replacement, see a live preview of every match, then apply (on-screen hints show the apply key). No `:s` regex or flags. |
| **Single file, confirm each** | `:%s/old/new/gc` — `g` = every match on the line, `c` = confirm each, `i` = case-insensitive, `e` = don't error if no match |
| **Selection only** | select visually, press `:`, nvim fills `:'<,'>`, add `s/old/new/g` |
| **Surgical few-at-a-time** | `/old<CR>` → `cgn`new`<Esc>` → `.` changes the next match, `n` skips. Faster than `:%s` for a handful of spots |

> Example — turn `version 1234` into `version 3215` everywhere: `<leader>sr`,
> search `version 1234`, replace `version 3215`, preview, apply.

## Jump & move (flash.nvim)

- `s` + 2 chars → jump to any visible word (labels appear on screen)
- `S` → pick a **treesitter** node (function, block, etc.) to operate on
- after an operator (`d` / `c` / `y`), press `r` → use flash as the motion
  (e.g. `d r` deletes to a flashed target)

## Text objects (mini.ai)

| Keys | Object |
|---|---|
| `ciw` / `daw` | inner word / around word |
| `ci"` `ci(` `ci{` | inside quotes / parens / braces |
| `cip` / `cap` | inside / around paragraph |
| `cif` / `cii` | inside function / indent block |
| `cit` / `cat` | inside / around tag |
| `daa` / `cia` | delete/change **around** an argument |

## Case (coerce.nvim)

`cr` then a letter: `crs` snake_case · `crc` camelCase · `cru` UPPER · `crl` lower ·
`cr-` kebab-case · `cr.` dot.case · bare `cr` to pick from a menu.

## The two biggest speed keys

- **`.`** — repeat the last change. Combined with `n` (next match) or flash, it turns one
  edit into many. Often beats `:%s` for visual edits.
- **macros** — `qa…q` records to register `a`; `@a` replays; `@@` repeats the last macro;
  `99@a` runs it 99×. Perfect for repetitive, line-by-line transformations.

## Everyday keys (LazyVim defaults)

`gcc` toggle comment · `<leader>sg` grep · `<leader>ff` files · `<leader>,` switch buffer ·
`<leader>gg` lazygit · `<c-/>` terminal · `gd` go-to-def · `gr`/`grr` references ·
`<leader>bd` close buffer · `]b`/`[b` next/prev buffer · `<leader>e` explorer
(where `a` add, `r` rename, `c`/`m`/`p` copy/move/paste, `d` delete).
