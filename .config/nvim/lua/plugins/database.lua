return {
	"tpope/vim-dadbod",
	event = "VeryLazy",
	dependencies = { "kristijanhusak/vim-dadbod-ui" },
	config = function()
		local lk = require("core.keymaps").lk
		local nmap = require("core.utils").norm_keyset
		local gv = vim.g
		gv["db_ui_save_location"] = "~/.config/db_ui"
		gv["dd_ui_use_nerd_fonts"] = 1
		nmap(lk.database.key .. "u", "DBUIToggle<CR>", "Toggle DB UI")
		nmap(lk.database.key .. "f", "DBUIFindBuffer<CR>", "Find DB Buffer")
		nmap(lk.database.key .. "r", "DBUIRenameBuffer<CR>", "Rename DB Buffer")
		nmap(lk.database.key .. "l", "DBUILastQueryInfo<CR>", "Run Last Query")
	end,
}
