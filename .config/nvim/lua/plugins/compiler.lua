return {
	"mesa123123/compiler.nvim",
	cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
	dependencies = {
		"stevearc/overseer.nvim",
		commit = "68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		opts = {
			task_list = {
				direction = "bottom",
				min_height = 15,
				max_height = 15,
				default_detail = 1,
			},
		},
	},
	config = function()
		---------------------------------"
		-- Code Execution - compiler.nvim, overseer, vimtext
		---------------------------------"

		-- Requires
		----------
		local nmap = require("core.utils").norm_keyset
		local lk = require("core.keymaps").lk
		----------

		-- Mappings
		----------
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			callback = function()
				leader_key = require("core.keymaps").lk.exec.key
				if vim.bo.filetype == "tex" then
					vim.keymap.set(
						"n",
						leader_key .. "x",
						"<cmd>VimtexCompile<CR>",
						{ silent = true, noremap = false, desc = "Compile Doc" }
					)
				else
					vim.keymap.set(
						"n",
						leader_key .. "x",
						"<cmd>CompilerOpen<CR>",
						{ silent = true, noremap = false, desc = "Run Code" }
					)
				end
			end,
		})
		nmap(lk.exec.key .. "q", "CompilerStop", "Stop Code Runner")
		nmap(lk.exec.key .. "i", "CompilerToggleResults", "Show Code Run")
		nmap(lk.exec.key .. "r", "CompilerStop<cr>" .. "<cmd>CompilerRedo", "Re-Run Code")
	end,
}
