--------------------------------
-- ###################  --
-- #  Plugin Config  #  --
-- ###################  --
--------------------------------

local M = {}

M.list = {
  { "nvim-lua/plenary.nvim", event = "VeryLazy" },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-context",
    },
  },
  {
    "vhyrro/luarocks.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    priority = 1000,
    config = true,
  },
  "folke/neodev.nvim",
  -- Autocompletion & Snips
  ----------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Sources
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "ray-x/cmp-treesitter",
      "SergioRibera/cmp-dotenv",
      "dmitmel/cmp-cmdline-history",
      "yochem/cmp-htmx",
      "saadparwaiz1/cmp_luasnip",
      "f3fora/cmp-spell",
      "jmbuhr/otter.nvim",
      -- Dependencies
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "rcarriga/nvim-notify",
    },
  },
  -- Language Server Protocol
  ----------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason.nvim",
      "ray-x/lsp_signature.nvim",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
  },
  { "jose-elias-alvarez/null-ls.nvim", branch = "main" },
  -- Linting Plugins
  ----------
  { "mfussenegger/nvim-lint", event = "VeryLazy" },
  -- Formatting
  ----------
  { "stevearc/conform.nvim", event = "VeryLazy" },
  -- Inejected Languages
  ----------
  "jmbuhr/otter.nvim",
  -- Debug Adapter Protocol
  ----------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Python Funcs
      "mfussenegger/nvim-dap-python",
      -- NvimConfig Funcs
      "jbyuki/one-small-step-for-vimkind",
      -- Cool Ui Elements
      "theHamsta/nvim-dap-virtual-text",
    },
  },
  -- Code Running
  ----------
  {
    "mesa123123/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
  },
  {
    "stevearc/overseer.nvim",
    commit = "68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 15,
        max_height = 15,
        default_detail = 1,
      },
    },
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "vhyrro/luarocks.nvim" },
    config = function()
      require("rest-nvim").setup()
    end,
  },
  ----------
  -- Assistance Plugins
  ----------
  "folke/which-key.nvim",
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, event = "VeryLazy" },
  { "numToStr/Comment.nvim", lazy = false },
  -- Testing Plugins
  --------
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio", -- Currently broken on my config....
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      -- "rouge8/neotest-rust",
      "andythigpen/nvim-coverage",
    },
    event = "VeryLazy",
  },
  -- Database Workbench,
  -----------
  { "tpope/vim-dadbod", event = "VeryLazy", dependencies = "kristijanhusak/vim-dadbod-ui" },
  -- Versions Control
  ----------
  { "tpope/vim-fugitive", event = "VeryLazy" },
  -- Status/Window Lines
  ------------
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
  },
  -- nicer-looking tabs with close icons
  {
    "nanozuki/tabby.nvim",
    enabled = true,
    config = function()
      require("tabby.tabline").use_preset("tab_only")
    end,
  },
  -- scrollbar
  {
    "dstein64/nvim-scrollview",
    enabled = true,
    opts = {
      current_only = true,
      signs_on_startup = {},
    },
  },
  {
    "utilyre/barbecue.nvim",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
  },
  ------------
  -- Colors and Themes
  ------------
  -- DevIcons
  "nvim-tree/nvim-web-devicons",
  -- Theme
  "ellisonleao/gruvbox.nvim",
  -- Brackets Rainbowing
  "luochen1990/rainbow",
  -- Highlights Hex Colors as their color
  "norcalli/nvim-colorizer.lua",
  -- Rainbow csv hl
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },
  -- LSP Icons
  { "onsails/lspkind.nvim", event = "VeryLazy" },
  -- Dashboard
  {
    "startup-nvim/startup.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  -- Folding
  ----------
  "anuvyklack/pretty-fold.nvim",
  ----------
  -- CmdLine
  ----------
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  ----------
  -- Nvim Telescope
  ---------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "BurntSushi/ripgrep",
      "sharkdp/fd",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "piersolenski/telescope-import.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    event = "VeryLazy",
  },
  ----------
  -- Writing Functionality
  ----------
  -- Wiki - Obsidian nvim
  { "epwalsh/obsidian.nvim", event = "VeryLazy" },
  -- Latex - VimTex
  "lervag/vimtex",
  ----------
  -- Alignment
  { "junegunn/vim-easy-align", event = "VeryLazy" },
  -- Working with Kitty
  { "fladson/vim-kitty", branch = "main" },
  -- Terminal Behaviour
  { "akinsho/toggleterm.nvim", version = "v2.*" },
  -- Notebooks
  ----------
  {
    "quarto-dev/quarto-nvim",
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 12
    end,
  },
  ----------
  -- Vim tutor Ext
  "ThePrimeagen/vim-be-good",
}

M.opts = {}

M.rocks = { "magick", "nvim-nio", "mimetypes" }

return M
