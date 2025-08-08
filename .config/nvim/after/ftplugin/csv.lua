vim.wo.wrap = false
require("config.utils").delim_move(",")
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.csv",
  callback = function()
    vim.cmd("RainbowShrink")
  end,
  desc = "Run RainbowShrink on Save",
})
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.csv",
  callback = function()
    vim.cmd("RainbowAlign")
  end,
  desc = "Run RainbowAlign on Open",
})
