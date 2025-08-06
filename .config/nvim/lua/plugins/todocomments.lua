return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lk = require("config.keymaps").lk
    local palette = require("config.theme").palette
    local keyopts = require("config.utils").keyopts
    local nmap = require("config.utils").norm_keyset
    require("todo-comments").setup({
      keywords = {
        LOOKUP = { icon = "󱛉", color = "lookup" },
        QUESTION = { icon = "󱛉", color = "lookup" },
        COMMENT = { icon = "󰅺", color = "comment" },
        TODO = { icon = "󰟃", color = "todo" },
        BUG = { icon = "󱗜", color = "jirabug" },
        WORKAROUND = { icon = "󱗜", color = "jirabug" },
        EOWA = { icon = "󱗜", color = "jirabug" },
        IMPROVE = { icon = "󰔵", color = "improve" },
        FEATURE = { icon = "󰔵", color = "improve" },
        PLUGIN = { icon = "󰔵", color = "improve" },
        MARK = { icon = "󰓾", color = "bookmark" },
        TASK = { icon = "", color = "jiratask" },
        DEV = { icon = "󰇦", color = "devcomment" },
        SUGGESTION = { icon = "󰇦", color = "devcomment" },
      },
      colors = {
        lookup = { palette.faded_purple },
        todo = { palette.neutral_blue },
        jirabug = { palette.bright_red },
        jiratask = { palette.bright_blue },
        devcomment = { palette.neutral_green },
        improve = { palette.faded_purple },
        bookmark = { palette.neutral_green },
        comment = { palette.gray },
      },
    })
    ----------

    -- Mappings
    ----------
    vim.keymap.set("n", "]t", function()
      require("todo-comments").jump_next()
    end, keyopts({ desc = "Next todo comment" }))

    vim.keymap.set("n", "[t", function()
      require("todo-comments").jump_prev()
    end, keyopts({ desc = "Previous todo comment" }))

    nmap(lk.todo.key, "TodoTelescope", "List Todos")
    ----------
  end,
}
