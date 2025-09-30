vim.opt_local.commentstring = "[//]: # (%s)"
vim.wo.spell = true
<<<<<<< HEAD
vim.opt_local.spelllang = "en_gb"
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
=======
vim.bo.spelllang = "en_gb"
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
>>>>>>> 457a4f0351bbadda580bc2de0803e4d92eb76394
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
