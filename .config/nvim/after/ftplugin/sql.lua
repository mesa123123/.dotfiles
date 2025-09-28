vim.bo.commentstring = "-- %s"
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.opt_local.colorcolumn = "90"

local makeDescMap = require("config.utils").desc_keymap
local lk = require("config.keymaps").lk
makeDescMap({ "v" }, lk.uniqueft, "r", function()
  vim.cmd('normal! "vy')
  local old_selection = vim.fn.getreg("v")
  if old_selection == "" then
    vim.notify("No text selected! Please select 'column_name::datatype' in visual mode.", vim.log.levels.ERROR)
    return
  end
  local old_col, datatype = old_selection:match("^(.-)::(.-)$")
  if not old_col or not datatype then
    vim.notify("Invalid selection! Please select 'column_name::datatype'.", vim.log.levels.ERROR)
    return
  end
  local new_col = vim.fn.input("Enter new column name: ")
  if new_col == "" then
    return
  end -- Exit if no input
  local old_selection_escaped = vim.pesc(old_selection)
  vim.cmd(string.format("%%s/\\<%s\\>/%s::%s AS %s/g", old_selection_escaped, new_col, datatype, old_col))
  vim.notify(
    string.format("Replaced '%s' with '%s::%s AS %s'", old_selection, new_col, datatype, old_col),
    vim.log.levels.INFO
  )
end, "[R]ename Typed SQL Column ")
