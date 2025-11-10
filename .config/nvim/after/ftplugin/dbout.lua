require("config.utils").delim_move("|")
local descMap = require("config.utils").desc_keymap
local lk = require("config.keymaps").lk

descMap({ "n" }, lk.uniqueft, "r", ":DBResulttoCSV<CR>", "Move Result to CSV")

local db_group = vim.api.nvim_create_augroup("DBCustom", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "DBExecutePost",
  group = db_group,
  callback = function()
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = db_group,
      pattern = "*",
      once = true,
      callback = function()
        if vim.bo.filetype == "dbout" then
          vim.cmd("DBResulttoCSV")
          vim.cmd("bdelete #")
        end
      end,
    })
  end,
})
