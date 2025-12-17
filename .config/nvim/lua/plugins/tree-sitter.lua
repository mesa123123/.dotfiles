--------------------------------
--  Syntax Highlighting: Tree-Sitter Config
--------------------------------
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
  },
  config = function()
    local treesitter = vim.treesitter
    local utils = require("config.utils")
    local nmap = utils.norm_keyset
    -- Plugin Setup
    ----------
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "css",
        "comment",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "graphql",
        "html",
        "htmldjango",
        "http",
        "javascript",
        "jinja",
        "jsonc",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "requirements",
        "rst",
        "rust",
        "terraform",
        "toml",
        "typescript",
        "vim",
        "yaml",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = { "csv" },
      },
      ident = { enable = true },
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
        colors = {},
      },
      modules = {},
      sync_install = true,
      ignore_install = {},
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      injections = {
        enable = true,
      },
      playground = {
        enable = true,
        updatetime = 25, -- Debounced time for highlighting nodes
        persist_queries = false,
      },
    })

    -- Custom Filetypes
    treesitter.language.register("markdown", "quarto")
    ----------

    -- Mappings
    ----------
    -- Context Bar - W/TS Context
    nmap("<leader>hc", "TSContextEnable", "Context Highlight On")
    nmap("<leader>hs", "TSContextDisable", "Context Highlight Off")
    nmap("<leader>ht", "TSContextToggle", "Context Highlight Toggle")
    nmap("[c", 'lua require(treesitter-context").go_to_context(vim.v.count1)', "Context Highlight Toggle")
    ----------
  end,
}
