return {
  {
    "vhyrro/luarocks.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    priority = 1000,
    config = true,
  },
  -- StatusLine
  ----------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
    config = function()
      require("lualine").setup(require("config").line_config)
    end,
  },
  ----------
  -- Outline
  ----------
  {
    "hedyhli/outline.nvim",
    config = function()
      local utils = require("config.utils")
      local descMap = utils.desc_keymap
      local lk = require("config.keymaps").lk
      descMap({ "n" }, lk.explore, "e", ":Outline<CR>", "Outline")
      require("outline").setup({
        outline_window = {
          show_numbers = true,
          show_relative_numbers = true,
        },
      })
    end,
  },
  -- Telescope
  ----------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "BurntSushi/ripgrep",
      "sharkdp/fd",
      "nvim-telescope/telescope-dap.nvim",
      "piersolenski/telescope-import.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "stevearc/oil.nvim",
      "refractalize/oil-git-status.nvim",
      "leath-dub/snipe.nvim",
    },
    event = "VeryLazy",
    config = function()
      local ftree = require("config").filetree
      require("telescope").setup(ftree.telescope_config())
      require("snipe").setup(ftree.snipe_config)
      require("oil").setup(ftree.file_tree_config)
      require("oil-git-status").setup()
      ftree.extension_load()
      ftree.set_mappings()
    end,
  },
  ----------
  -- Linting & Formatting Plugins
  ----------
  { "mfussenegger/nvim-lint", event = "VeryLazy" },
  { "stevearc/conform.nvim", event = "VeryLazy" },
  ----------
  -- Tools Manager
  ----------
  {
    "williamboman/mason.nvim",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
  },
  ----------
  -- Debug Adapter Protocol
  ----------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("config.dap_config").setup()
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
    "echasnovski/mini.clue",
    config = function()
      local miniclue = require("mini.clue")
      local all_clues = {}

      local function add_clues(clue_list)
        for _, clue in ipairs(clue_list) do
          table.insert(all_clues, clue)
        end
      end

      add_clues(miniclue.gen_clues.g())
      add_clues(require("config.keymaps").get_leader_descriptions())
      add_clues(miniclue.gen_clues.g())
      add_clues(miniclue.gen_clues.z())
      -- add_clues(miniclue.gen_clues.builtin_completion())
      -- add_clues(miniclue.gen_clues.marks())
      -- add_clues(miniclue.gen_clues.registers())
      -- add_clues(miniclue.gen_clues.windows())
      miniclue.setup({
        triggers = {
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "v", keys = "<Leader>" },
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },
        },
        clues = all_clues,
      })
    end,
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
  { "echasnovski/mini.starter", event = "VimEnter", version = false },
  {
    "fei6409/log-highlight.nvim",
    config = function()
      require("log-highlight").setup({
        extensions = { "log", "output" },
      })
    end,
  },
  ----------
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
        latex = { enabled = false },
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
