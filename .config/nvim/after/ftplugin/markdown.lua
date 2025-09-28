vim.bo.commentstring = "[//]: # %s"
vim.wo.spell = true
vim.bo.spelllang = "en_gb"
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.keymap.set("i", "<TAB>", "<C-t>", {})
vim.opt_local.formatoptions:append("r")
vim.opt_local.formatoptions:append("o")
vim.opt_local.comments = {
  "b:- [ ]",
  "b:- [x]",
  "b:*",
  "b:-",
  "b:+",
}
