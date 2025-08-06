return {
	"mesa123123/compiler.nvim",
	cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
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
		vim.keymap.set("n", "<leader>xx", function()
			if vim.bo.filetype == "tex" then
				vim.cmd.VimtexCompile()
			else
				vim.cmd.CompilerOpen()
			end
		end, { silent = true, noremap = false, desc = "Run Code" })
		nmap(lk.exec.key .. "q", "CompilerStop", "Stop Code Runner")
		nmap(lk.exec.key .. "i", "CompilerToggleResults", "Show Code Run")
		nmap(lk.exec.key .. "r", "CompilerStop<cr>" .. "<cmd>CompilerRedo", "Re-Run Code")
	end,
}
