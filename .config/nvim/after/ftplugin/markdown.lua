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

-- local injection_languagues = { "sql", "python", "lua", "bash" }
--
-- local constant_query = [[
-- ;; Make the top block respond to yaml
-- ((front_matter) @yaml)
-- ]]
--
-- local dynamic_query = [[
--   (fenced_code_block 
--     (info_string (language) @_language) (code_fence_content) @injection.content (#set! injection.language "%s") (#match? @_language "%s"))
-- ]]
--
-- local full_query =
--   require("config.utils").create_treesitter_injection_query(constant_query, dynamic_query, injection_languagues)
-- vim.treesitter.query.set("markdown", "injections", full_query)
