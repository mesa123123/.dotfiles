return {
  {
    "vhyrro/luarocks.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    priority = 1000,
    config = true,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = { mappings = false },
    },
  },
  -- Linting Plugins
  ----------
  { "mfussenegger/nvim-lint", event = "VeryLazy" },
  -- Formatting
  ----------
  { "stevearc/conform.nvim", event = "VeryLazy" },
  ----------
  -- Tools Manager
  ----------
  {
    "williamboman/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "jay-babu/mason-nvim-dap.nvim",
      "jay-babu/mason-null-ls.nvim",
      -- neodev
      "folke/neodev.nvim",
      -- Nice popup windows
      "ray-x/lsp_signature.nvim",
    },
  },
  { "neovim/nvim-lsp-config", url = "git@github.com:neovim/nvim-lspconfig.git", lazy = false },
  ----------
  -- Debug Adapter Protocol
  ----------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Python Funcs
      "mfussenegger/nvim-dap-python",
      -- NvimConfig Funcs - This is the debugger for your config
      "jbyuki/one-small-step-for-vimkind",
      -- Cool Ui Elements
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("lsp_config.dap_config")
    end,
  },
  ----------
  -- Version Control
  ----------
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      local vcs_config = require("config.vcs")
      vcs_config.mappings()
      vcs_config.tele_mappings()
    end,
  },
  ----------
  -- UI Stuff
  ----------
  -- Icons
  {
    "echasnovski/mini.icons",
    config = function()
      require("mini.icons").setup({
        lsp = {
          snippet = {
            glyph = "",
            hl = "miniiconsgreen",
          },
        },
      })
    end,
  },
  -- Notifications
  {
    "echasnovski/mini.notify",
    version = "*",
    config = function()
      require("mini.notify").setup()
    end,
  },
  {
    "dstein64/nvim-scrollview",
    enabled = true,
    opts = {
      current_only = true,
      signs_on_startup = {},
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "tris203/precognition.nvim",
    opts = {
      startVisible = true,
      hints = {
        Caret = { text = "^", prio = 4 },
        Dollar = { text = "L", prio = 5 },
        MatchingPair = { text = "%", prio = 4 },
        Zero = { text = "H", prio = 5 },
        w = { text = "w", prio = 1 },
        b = { text = "b", prio = 1 },
        e = { text = "e", prio = 1 },
        W = { text = "W", prio = 2 },
        B = { text = "B", prio = 2 },
        E = { text = "E", prio = 2 },
      },
    },
  },
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
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
  { "onsails/lspkind.nvim", event = "VeryLazy" },
  -- Dashboard
  {
    "startup-nvim/startup.nvim",
    event = "VimEnter",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  -- Syntax Stuff
  {
    "fei6409/log-highlight.nvim",
    config = function()
      require("log-highlight").setup({
        extensions = { "log", "output" },
      })
    end,
  },
  ----------
  -- CmdLine
  ----------
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  ----------
  -- Writing Functionality
  ----------
  -- Wiki - Obsidian nvim
  { "epwalsh/obsidian.nvim", event = "VeryLazy" },
  -- Latex - VimTex
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.tex" },
        callback = function()
          vim.g["vimtext_view_method"] = "zathura"
        end,
      })
    end,
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- Setup render-markdown
      require("render-markdown").setup({
        completions = { blink = { enabled = true } },
      })
    end,
    opts = {
      file_types = { "markdown", "codecompanion" },
      render_modes = { "n", "c", "t" },
    },
    ft = { "markdown", "codecompanion" },
  },
  ----------
}
