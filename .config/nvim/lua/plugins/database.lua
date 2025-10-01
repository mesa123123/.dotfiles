return {
  {
    "tpope/vim-dadbod",
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    config = function()
      local home = vim.fn.expand("$HOME")
      local rc_path = home .. "/.bigqueryrc"

      local f = io.open(rc_path, "r")
      if f then
        f:close()
        return
      end

      local out = io.open(rc_path, "w")
      if out then
        out:write("[query]\n--use_legacy_sql=false\n")
        out:close()
        vim.notify("Created ~/.bigqueryrc (--use_legacy_sql=false)", vim.log.levels.INFO)
      else
        vim.notify("Failed to write ~/.bigqueryrc", vim.log.levels.ERROR)
      end
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
    },
    config = function()
      local lk = require("config.keymaps").lk
      local nmap = require("config.utils").norm_keyset
      local gv = vim.g
      local api = vim.api

      local dbcons_file = "~/.config/db_ui_connections/connections.json"
      gv["db_ui_save_location"] = "~/.config/db_ui_connections"
      gv.db_ui_use_nerd_fonts = 1

      api.nvim_create_user_command("EditDbConns", "e " .. dbcons_file .. "", {})

      nmap(lk.database.key .. "u", "DBUIToggle<CR>:set nu<CR>:set relativenumber", "Toggle DB UI")
      nmap(lk.database.key .. "f", "DBUIFindBuffer", "Find DB Buffer")
      nmap(lk.database.key .. "r", "DBUIRenameBuffer", "Rename DB Buffer")
      nmap(lk.database.key .. "l", "DBUILastQueryInfo", "Run Last Query")
      vim.keymap.set({ "n", "v" }, lk.database.key .. "x", "<Plug>(DBUI_ExecuteQuery)", { desc = "Run Query" })
    end,
  },
}
