-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Ensure mise-managed tools (e.g. go) are available to vim.system()
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

-- [[ Setting options ]]

vim.o.background = "light"  -- My terminal has a light background, choose colors accordingly
vim.o.breakindent = true  -- Enable break indent
vim.o.undofile = true  -- Save undo history
vim.o.inccommand = "split"  -- Preview substitutions live, as you type!
vim.o.cursorline = true  -- Show which line your cursor is on
vim.o.scrolloff = 5  -- Minimal number of screen lines to keep above and below the cursor.

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sets how neovim will display certain whitespace characters in the editor.
-- vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- [[ Basic Keymaps ]]

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
-- I'm used to these, but I should probably switch to the standard ]d [d ones
vim.keymap.set("n", "]w", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic/warning" })
vim.keymap.set("n", "[w", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic/warning" })
vim.keymap.set("n", "]e", function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })
vim.keymap.set("n", "[e", function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Previous error" })

-- Move lines up and down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Yank file references to system clipboard
vim.keymap.set("n", "<leader>yf", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Yank file reference" })
vim.keymap.set("n", "<leader>yl", function()
  vim.fn.setreg("+", vim.fn.expand("%") .. ":" .. vim.fn.line("."))
end, { desc = "Yank file:line reference" })
vim.keymap.set("v", "<leader>yl", function()
  local s, e = vim.fn.line("'<"), vim.fn.line("'>")
  vim.fn.setreg("+", vim.fn.expand("%") .. ":" .. s .. (e ~= s and ("-" .. e) or ""))
end, { desc = "Yank file:lines reference" })

-- Reload files changed outside of Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime",
})
vim.o.autoread = true
vim.o.updatetime = 250

-- Highlight when yanking (copying) text. Try it with `yap` in normal mode
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--  To check the current status of your plugins, run :Lazy
require("lazy").setup({
  {
    "dchinmay2/alabaster.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("alabaster")
    end,
  },
  { "NMAC427/guess-indent.nvim", opts = {} }, -- Detect tabstop and shiftwidth automatically
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "tpope/vim-dispatch",
  "tpope/vim-eunuch",
  "wsdjeg/vim-fetch",  -- For opening file:line:col locations and gF command

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Next git change" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Previous git change" })
      end,
    },
  },

  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      spec = {
        { "<leader>s", group = "[S]earch" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
        { "<leader>y", group = "[Y]ank" },
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make", -- `build` is used to run some command when the plugin is installed/updated.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.999,
            height = 0.999,
          },
        },
        extensions = {
          -- Replace Neovim's default selection prompts (vim.ui.select) with Telescope pickers
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },

  -- LSP Plugins
  {
    -- lazydev configures Lua LSP for your Neovim config, runtime and plugins
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} },  -- LSP status updates
      "saghen/blink.cmp",  -- Extra capabilities for completion
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local tb = require("telescope.builtin")
          map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
          map("grr", tb.lsp_references, "[G]oto [R]eferences")
          map("gri", tb.lsp_implementations, "[G]oto [I]mplementation")
          map("grd", tb.lsp_definitions, "[G]oto [D]efinition")
          map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gO", tb.lsp_document_symbols, "Open Document Symbols")
          map("gW", tb.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
          map("grt", tb.lsp_type_definitions, "[G]oto [T]ype Definition")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- Inlay hints displace code, so toggle rather than enable by default
          if
            client
            and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
          then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Diagnostic Config, see :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = { source = "if_many" },
      })

      -- blink.cmp adds completion capabilities beyond Neovim's defaults
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- See `:help lspconfig-all` for the list of pre-configured LSPs
      local servers = {
        gopls = {},
        rust_analyzer = {},
        ruff = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
            },
          },
        },
      }

      -- Servers must be installed separately (e.g. `go install gopls@latest`,
      -- `rustup component add rust-analyzer`, `uv tool install ruff-lsp`)
      for server_name, server_config in pairs(servers) do
        vim.lsp.config(server_name, vim.tbl_deep_extend("force", { capabilities = capabilities }, server_config))
        vim.lsp.enable(server_name)
      end
    end,
  },

  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable format_on_save for languages without a standardized style
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then return end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  { -- Autocompletion
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        opts = {},
      },
      "folke/lazydev.nvim",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",

        -- Disable blink.cmp's Ctrl-P/Ctrl-N so Vim's native buffer completion works
        ["<C-p>"] = {},
        ["<C-n>"] = {},
      },

      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },

      snippets = { preset = "luasnip" },

      fuzzy = { implementation = "lua" },

      signature = { enabled = true },
    },
  },

  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Highlight other uses of the word under the cursor (LSP → treesitter → regex)
  "RRethy/vim-illuminate",

  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.surround").setup()
    end,
  },
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Sets main module to use for opts
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      multiline_threshold = 1  -- Maximum number of lines to show for a single context
    }
  }
}, {
  install = { colorscheme = { "default" } },
})

-- vim: ts=2 sts=2 sw=2 et
