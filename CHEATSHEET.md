# Dev Environment Cheatsheet

---

## Neovim

### Modes
| Key | What it does |
|---|---|
| `Esc` | Return to normal mode |
| `i` | Enter insert mode (type here) |
| `v` | Enter visual mode (select text) |
| `:` | Enter command mode |

### Navigation
| Key | What it does |
|---|---|
| `h j k l` | Move left / down / up / right |
| `w` | Jump forward one word |
| `b` | Jump back one word |
| `gg` | Go to top of file |
| `G` | Go to bottom of file |
| `Ctrl+o` | Jump back (after go-to-definition) |
| `Ctrl+u` | Scroll up half page |
| `Ctrl+d` | Scroll down half page |

### Editing
| Key | What it does |
|---|---|
| `dd` | Delete current line |
| `yy` | Copy current line |
| `p` | Paste below |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `gcc` | Toggle comment on current line |
| `gc` | Toggle comment on visual selection |
| `cs"'` | Change surrounding `"` to `'` |
| `ds"` | Delete surrounding `"` |
| `ysiw"` | Add `"` around word under cursor |

### Saving & quitting
| Key | What it does |
|---|---|
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |

### Search
| Key | What it does |
|---|---|
| `/word` | Search forward for word |
| `n` | Next match |
| `N` | Previous match |
| `Esc` | Clear search highlights |

### Windows & splits
| Key | What it does |
|---|---|
| `:vsp` | Vertical split |
| `:sp` | Horizontal split |
| `Ctrl+h/j/k/l` | Move between splits |
| `:q` | Close current split |

### Telescope (fuzzy find) — Space prefix
| Key | What it does |
|---|---|
| `Space ff` | Find file in project |
| `Space fg` | Live grep across all files |
| `Space fb` | Switch between open buffers |
| `Space fh` | Search vim help |
| `Ctrl+v` | Open result in vertical split |
| `Ctrl+x` | Open result in horizontal split |

### File tree (Neo-tree)
| Key | What it does |
|---|---|
| `Space e` | Toggle file explorer |
| `Enter` | Open file / expand folder |
| `a` | Create new file |
| `d` | Delete file |
| `r` | Rename file |
| `q` | Close tree |

### LSP (language server)
| Key | What it does |
|---|---|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover docs |
| `Space rn` | Rename symbol |
| `Space ca` | Code action (auto-fix) |
| `Space d` | Show diagnostic detail |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Git (gitsigns + fugitive)
| Key | What it does |
|---|---|
| `]h` | Next changed hunk |
| `[h` | Previous changed hunk |
| `Space gb` | Git blame current line |
| `Space gd` | Diff current file |
| `:Git` | Open git status |
| `:Git log` | Commit history |
| `:Git blame` | Full file blame |
| `:Git push` | Push |

---

## Tmux
*Prefix is `Ctrl+a` — press it before every tmux command*

### Sessions
| Key | What it does |
|---|---|
| `tmux` | Start new session |
| `tmux attach` | Reattach to last session |
| `Prefix d` | Detach (session keeps running) |

### Windows
| Key | What it does |
|---|---|
| `Prefix c` | New window |
| `Prefix 1-9` | Switch to window by number |
| `Prefix n` | Next window |
| `Prefix p` | Previous window |

### Panes
| Key | What it does |
|---|---|
| `Prefix \|` | Split vertically (left/right) |
| `Prefix -` | Split horizontally (top/bottom) |
| `Prefix h/j/k/l` | Move between panes |
| `Prefix H/J/K/L` | Resize pane |
| `Prefix x` | Close current pane |
| `Prefix r` | Reload tmux config |

---

## Git
*Aliases set in `.gitconfig`*

| Command | What it does |
|---|---|
| `git st` | Status |
| `git lg` | Last 10 commits, compact |
| `git lga` | Full branch graph |
| `git d` | Diff |
| `git ds` | Diff staged changes |
| `git undo` | Undo last commit, keep changes |
| `git aliases` | List all aliases |

### Branch conventions
```
feat/short-description    new feature
fix/short-description     bug fix
refactor/description      refactor
chore/description         maintenance
exp/description           experiment
```

---

## Zsh aliases

| Alias | What it does |
|---|---|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `ll` | `ls -la` |
| `gs` | `git status` |
| `gl` | `git log --oneline -10` |
| `gd` | `git diff` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gco` | `git checkout` |
| `gb` | `git branch` |
| `venv` | `uv venv` (create `.venv`) |
| `activate` | `source .venv/bin/activate` |
| `vim` | `nvim` |
| `v` | `nvim` |

---

## uv (Python)

| Command | What it does |
|---|---|
| `uv python install 3.12` | Install Python 3.12 |
| `uv python pin 3.12` | Pin Python version for this project |
| `uv venv` | Create `.venv` in current directory |
| `uv pip install pandas` | Install a package |
| `uv pip install -r requirements.txt` | Install from requirements file |
| `uv run script.py` | Run script in project environment |

