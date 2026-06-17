-- =============================================================================
-- OPTIONS
-- =============================================================================

vim.opt.number         = true       -- show line numbers
vim.opt.relativenumber = true       -- relative numbers — jump with e.g. 12j or 5k
vim.opt.clipboard      = "unnamedplus" -- system clipboard (yank goes to Cmd+V)
vim.opt.mouse          = "a"        -- mouse support in all modes
vim.opt.termguicolors  = true       -- full colour support
vim.opt.updatetime     = 250        -- faster diagnostics (default 4000ms)
vim.opt.signcolumn     = "yes"      -- always show sign column (stops jitter)
vim.opt.splitright     = true       -- new vertical splits go right
vim.opt.splitbelow     = true       -- new horizontal splits go below
vim.opt.scrolloff      = 8          -- keep 8 lines visible above/below cursor
vim.opt.cursorline     = true       -- highlight current line
vim.opt.colorcolumn    = "88"       -- ruff/black line length guide
vim.opt.wrap           = false      -- no line wrapping

-- indentation (4 spaces, no tabs)
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true

-- search
vim.opt.ignorecase     = true       -- case-insensitive search...
vim.opt.smartcase      = true       -- ...unless you type a capital
vim.opt.incsearch      = true       -- show matches as you type
vim.opt.hlsearch       = true       -- highlight all matches
vim.opt.showmatch      = true       -- briefly jump to matching bracket

-- no backup files cluttering the repo
vim.opt.backup         = false
vim.opt.writebackup    = false
vim.opt.swapfile       = false

vim.cmd("filetype plugin indent on")


-- =============================================================================
-- KEYMAPS
-- =============================================================================
--
-- LEADER KEY is <Space>
-- When you see <leader> below, press Space first, then the next key(s).
--
-- READING THE NOTATION:
--   "n"       = normal mode (navigating)
--   "i"       = insert mode (typing)
--   "v"       = visual mode (selection)
--   <CR>      = Enter
--   <C-x>     = Ctrl + x
--   <D-x>     = Cmd + x  (Mac only)
--   <leader>x = Space + x
-- =============================================================================

vim.g.mapleader = " "

local map = vim.keymap.set

-- clear search highlight with Esc
-- usage: after searching, press Esc to remove the yellow highlights
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- system clipboard (Mac)
-- usage: in insert mode, Cmd+V pastes from system clipboard
-- usage: in normal/visual mode, Cmd+C copies selection to system clipboard
map("i", "<D-v>", "<C-r>+")
map({ "n", "v" }, "<D-c>", '"+y')

-- window navigation
-- usage: Ctrl+h/j/k/l to move between split windows
--        (same direction logic as hjkl movement in normal mode)
--   example: open a vertical split with :vsp, then Ctrl+h/l to switch sides
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Telescope fuzzy finder
-- usage: <Space>ff  — open file picker (fuzzy search filenames in project)
-- usage: <Space>fg  — live grep (search text content across all files)
-- usage: <Space>fb  — switch between open buffers (like tabs)
-- usage: <Space>fh  — search vim help topics
--   tip: in the picker, type to filter, Enter to open, Esc to close
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- file tree
-- usage: <Space>e  — toggle the file explorer panel on the left
map("n", "<leader>e", "<cmd>Neotree toggle<cr>")


-- =============================================================================
-- AUTOCMDS
-- (things that run automatically on certain events — you don't trigger these)
-- =============================================================================

-- restore cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local line = vim.fn.line([['"]])
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- briefly highlight yanked (copied) text
-- you'll see a flash when you yank with y — confirms what was copied
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})


-- =============================================================================
-- PLUGINS (lazy.nvim)
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- -------------------------------------------------------------------------
  -- COLOURSCHEME: rose-pine dawn
  -- -------------------------------------------------------------------------
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({ variant = "dawn" })
      vim.cmd("colorscheme rose-pine")
    end,
  },

  -- -------------------------------------------------------------------------
  -- TREESITTER — syntax highlighting
  -- installs language parsers that understand code structure (not just regex)
  -- you don't interact with this directly — it just makes code look better
  -- -------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "python", "lua", "rust", "toml", "markdown", "bash" },
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end,
  },

  -- -------------------------------------------------------------------------
  -- LSP STACK
  -- mason     — installs language servers (like an app store for LSPs)
  -- lspconfig — connects those servers to neovim
  --
  -- what this gives you (automatically, no keymaps needed for most):
  --   • red underlines on errors, yellow on warnings
  --   • autocomplete suggestions as you type
  --   • hover docs, go-to-definition, find references (keymaps below)
  -- -------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    config = function()
      -- usage: :Mason  — open the mason UI to see/install language servers
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "ruff", "lua_ls" },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- neovim 0.11+ API (replaces require("lspconfig").pyright.setup())
      vim.lsp.config("pyright", {})   -- type checking, go-to-def, hover docs
      vim.lsp.config("ruff", {})      -- lint + format
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })
      vim.lsp.enable({ "pyright", "ruff", "lua_ls" })

      -- LSP keymaps — active only when an LSP is attached to the buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf }

          -- gd  — go to definition: jump to where a function/class is defined
          --        (Ctrl+o to jump back)
          map("n", "gd", vim.lsp.buf.definition, opts)

          -- gr  — find references: show everywhere this symbol is used
          map("n", "gr", vim.lsp.buf.references, opts)

          -- K   — hover docs: show type info and docstring for symbol under cursor
          map("n", "K", vim.lsp.buf.hover, opts)

          -- <Space>rn — rename: rename a symbol everywhere in the project
          map("n", "<leader>rn", vim.lsp.buf.rename, opts)

          -- <Space>ca — code action: fix suggestions (auto-import, fix lint etc)
          map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

          -- <Space>d  — open floating window showing the error/warning detail
          map("n", "<leader>d", vim.diagnostic.open_float, opts)

          -- [d / ]d   — jump to previous/next diagnostic (error or warning)
          map("n", "[d", vim.diagnostic.goto_prev, opts)
          map("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })
    end,
  },

  -- -------------------------------------------------------------------------
  -- AUTOCOMPLETE (nvim-cmp)
  -- shows a dropdown as you type with completions from LSP, buffer, file paths
  --
  -- usage:
  --   Ctrl+Space      — manually trigger completion dropdown
  --   Tab / Shift+Tab — navigate up/down through suggestions
  --   Enter           — accept the selected suggestion
  --   Ctrl+e          — close/dismiss the dropdown
  -- -------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- -------------------------------------------------------------------------
  -- TELESCOPE — fuzzy finder
  -- (keymaps are up in the KEYMAPS section: <Space>ff/fg/fb/fh)
  --
  -- extra usage once the picker is open:
  --   Ctrl+j / Ctrl+k — move up/down in results (alternative to arrow keys)
  --   Ctrl+v          — open selected file in vertical split
  --   Ctrl+x          — open selected file in horizontal split
  --   Ctrl+t          — open selected file in new tab
  -- -------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy  = "horizontal",
          sorting_strategy = "ascending",
        },
      })
    end,
  },

  -- -------------------------------------------------------------------------
  -- NEO-TREE — file explorer
  -- (keymap: <Space>e to toggle)
  --
  -- usage once open:
  --   Enter / l — open file or expand folder
  --   h         — collapse folder
  --   a         — create new file (type name and Enter)
  --   d         — delete file
  --   r         — rename file
  --   q         — close the tree
  -- -------------------------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window     = { width = 30 },
        filesystem = { follow_current_file = { enabled = true } },
      })
    end,
  },

  -- -------------------------------------------------------------------------
  -- GIT
  -- gitsigns — shows changed lines in the gutter (left margin)
  -- fugitive  — run any git command from inside vim with :Git <command>
  --
  -- gitsigns keymaps (set in on_attach below):
  --   ]h              — jump to next changed hunk
  --   [h              — jump to previous changed hunk
  --   <Space>gb       — show git blame for current line
  --   <Space>gd       — show diff for current file
  --
  -- fugitive usage:
  --   :Git            — interactive git status (press g? for help inside it)
  --   :Git log        — commit history
  --   :Git blame      — full file blame view
  --   :Git diff       — diff against last commit
  --   :Git push       — push (same as running git push in terminal)
  -- -------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add    = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local o  = { buffer = bufnr }
          map("n", "]h", gs.next_hunk,   o)
          map("n", "[h", gs.prev_hunk,   o)
          map("n", "<leader>gb", gs.blame_line, o)
          map("n", "<leader>gd", gs.diffthis,   o)
        end,
      })
    end,
  },
  { "tpope/vim-fugitive" },

  -- -------------------------------------------------------------------------
  -- LUALINE — status bar at the bottom
  -- shows: mode | branch + diff + diagnostics | filename | filetype | position
  -- you don't interact with this directly
  -- -------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme               = "rose-pine",
          section_separators  = "",
          component_separators = "│",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- -------------------------------------------------------------------------
  -- EDITING UTILITIES
  -- -------------------------------------------------------------------------

  -- vim-surround
  -- usage: change, add, or delete surrounding characters
  --   cs"'        — change surrounding " to '   ("hello" → 'hello')
  --   cs'<p>      — change surrounding ' to <p> tags
  --   ds"         — delete surrounding "         ("hello" → hello)
  --   ysiw"       — add " around word under cursor (hello → "hello")
  --   yss)        — wrap entire line in parentheses
  { "tpope/vim-surround" },

  -- vim-commentary
  -- usage: comment/uncomment code
  --   gcc         — toggle comment on current line
  --   gc          — toggle comment on visual selection
  --   gcap        — comment out a paragraph
  { "tpope/vim-commentary" },

  -- conform.nvim — format on save
  -- runs ruff_format automatically when you save a Python file
  -- you don't need to do anything — just save with :w
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
        lua    = { "stylua" },
      },
      format_on_save = function(bufnr)
        if vim.bo[bufnr].buftype ~= "" then return end
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
    },
  },

  -- markdown-preview
  -- usage: :MarkdownPreview        — open current file in browser as rendered markdown
  --        :MarkdownPreviewStop    — close the preview
  --        :MarkdownPreviewToggle  — toggle on/off
  {
    "iamcco/markdown-preview.nvim",
    ft    = { "markdown" },
    cmd   = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init  = function() vim.g.mkdp_auto_start = 0 end,
  },

})
