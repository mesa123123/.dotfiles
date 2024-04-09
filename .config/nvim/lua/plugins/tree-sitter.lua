--------------------------------
--  Syntax Highlighting: Tree-Sitter Config
--------------------------------
return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
        local treesitter = vim.treesitter
        local utils = require('core.utils')
        local nmap = utils.norm_keyset
        -- Plugin Setup
        ----------
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "lua",
            "rust",
            "toml",
            "markdown",
            "markdown_inline",
            "html",
            "css",
            "htmldjango",
            "rst",
            "python",
            "bash",
            "vim",
            "go",
            "csv",
            "regex",
            "javascript",
            "typescript",
            "requirements",
            "jsonc",
            "latex",
            "http",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
          },
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "markdown", "rst" },
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
        })

        -- Custom Filetypes
        treesitter.language.register("htmldjango", "jinja")
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
    end
}

