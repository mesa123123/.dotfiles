vim.opt_local.commentstring = "[//]: # (%s)"
vim.wo.spell = true
vim.opt_local.spelllang = "en_gb"
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
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
