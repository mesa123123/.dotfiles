local load = function()
	local lk = require("core.keymaps").lk
	local keymap = vim.keymap
	-- Keymappings
	------------------
	keymap.set("n", lk.vcs.key .. "w", "<cmd>G blame<CR>", { silent = true, desc = "Git Who? (Blame)" })
	keymap.set("n", lk.vcs.key .. "m", "<cmd>G mergetool<CR>", { silent = true, desc = "Git Mergetool" })
	keymap.set("n", lk.vcs.key .. "a", "<cmd>Gwrite<CR>", { silent = true, desc = "Add Current File" })
	keymap.set("n", lk.vcs.key .. "c", ":Git commit -m ", { silent = true, desc = "Make a commit" })
	-- Telescope Functions - git
	----------
	-- Commits
	keymap.set(
		"n",
		lk.vcs_file.key .. "c",
		"<cmd>Telescope git_commits theme=dropdown theme=dropdown<cr>",
		{ silent = true, desc = "Git Commits" }
	)
	-- Status
	keymap.set(
		"n",
		lk.vcs_file.key .. "s",
		"<cmd>Telescope git_status theme=dropdown<cr>",
		{ silent = true, desc = "Git Status" }
	)
	-- Branches
	keymap.set(
		"n",
		lk.vcs_file.key .. "b",
		"<cmd>Telescope git_branches theme=dropdown<cr>",
		{ silent = true, desc = "Git Branches" }
	)
	-- Git Files
	keymap.set(
		"n",
		lk.vcs_file.key .. "f",
		"<cmd>Telescope git_files theme=dropdown<cr>",
		{ silent = true, desc = "Git Files" }
	)
	----------
end

return {
	"tpope/vim-fugitive",
	event = "VeryLazy",
	config = load,
}
