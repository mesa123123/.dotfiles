return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "saghen/blink.compat",
  },
  opts = {
    appearance = {
      nerd_font_variant = "mono", -- Or "normal"
    },
    fuzzy = { implementation = "lua" },
    sources = {
      default = { "omni", "lsp", "path", "buffer", "snippets" },
      per_filetype = {
        sql = { "omni", "lsp", "snippets", "buffer", "path" },
        markdown = { "markdown", "lsp", "snippets", "buffer", "path", "omni" },
        codecompanion = { "codecompanion", "path", "buffer" },
      },
    },
    keymap = {
      ["<C-l>"] = { "select_next", "fallback" },
      ["<C-h>"] = { "select_prev", "fallback" },
      ["<C-k>"] = { "scroll_documentation_up", "fallback" },
      ["<C-j>"] = { "scroll_documentation_down", "fallback" },
      ["<Esc>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-space>"] = {
        function(cmp)
          cmp.show({ providers = { "snippets" } })
        end,
      },
    },
    signature = { enabled = true },
    completion = {
      list = {
        max_items = 200,
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      menu = {
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                return kind_icon
              end,
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
            kind = {
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
          },
        },
      },
    },
  },
}
