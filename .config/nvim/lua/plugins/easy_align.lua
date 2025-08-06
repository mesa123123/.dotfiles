return {
	"junegunn/vim-easy-align",
	event = "VeryLazy",
	config = function()
		local lk = require("core.keymaps").lk
		local keymap = vim.keymap
		-- Start interactive EasyAlign in visual mode (e.g. vipga)
		keymap.set("x", lk.codeAction_alignment.key, "<Plug>(EasyAlign)<CR>", { desc = "Easy Align" })
		-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
		keymap.set("n", lk.codeAction_alignment.key, "<Plug>(EasyAlign)<CR>", { desc = "Easy Align" })
		----------
	end,
}
