return {
  "tpope/vim-dadbod",
  dependencies = { "kristijanhusak/vim-dadbod-ui", "kristijanhusak/vim-dadbod-completion" },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  config = function()
    -- Vims, Ims, Vars
    ----------
    local lk = require("config.keymaps").lk
    local nmap = require("config.utils").norm_keyset
    local gv = vim.g
    local api = vim.api
    ----------
    -- Options
    ----------
    local dbcons_file = "~/.config/db_ui_connections/connections.json"
    gv["db_ui_save_location"] = "~/.config/db_ui_connections"
    gv.db_ui_use_nerd_fonts = 1

    -- Commands
    ----------
    api.nvim_create_user_command("EditDbConns", "e " .. dbcons_file .. "", {})

    -- KeyMaps
    ----------
    nmap(lk.dataconfig.key .. "u", "DBUIToggle<CR>:set nu<CR>:set relativenumber", "Toggle DB UI")
    nmap(lk.dataconfig.key .. "f", "DBUIFindBuffer", "Find DB Buffer")
    nmap(lk.dataconfig.key .. "r", "DBUIRenameBuffer", "Rename DB Buffer")
    nmap(lk.dataconfig.key .. "l", "DBUILastQueryInfo", "Run Last Query")
    vim.keymap.set({ "n", "v" }, lk.dataconfig.key .. "x", "<Plug>(DBUI_ExecuteQuery)", { desc = "Run Query" })

    -- BigQuery Custom Driver Definition

    ------------------------------------------
    local bigquery_driver_func = function(connection_url, query_string)
      local project_id = connection_url:match("bigquery://([^/]+)")
      if not project_id then
        return "echo 'Error: BigQuery project ID not found in connection URL. Please ensure it is in the format: bigquery://your-project-id'"
      end
      local temp_file_path = vim.fn.tempname() .. ".sql"
      local file = io.open(temp_file_path, "w")
      if file then
        file:write(query_string)
        io.close(file)
      else
        return "echo 'Error: Could not create temporary file for BigQuery query.'"
      end
      local cmd =
        string.format("bq --project_id=%s query --nouse_legacy_sql --format=csv < %s", project_id, temp_file_path)
      return cmd
    end
    if not gv.dadbod_drivers then
      gv.dadbod_drivers = {}
    end
    gv.dadbod_drivers.bigquery = bigquery_driver_func
  end,
}
----------
