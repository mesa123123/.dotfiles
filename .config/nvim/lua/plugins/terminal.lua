----------------------------------
-- Terminal Settings: <leader>t & <leader>a - toggleterm
----------------------------------

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local lk = require("core.keymaps").lk
		local nmap = require("core.utils").norm_keyset
		local fn = vim.fn
		local cmd = vim.cmd
		local keymap = vim.keymap
		-- Setup
		----------
		local default_terminal_opts = {
			persist_mode = true,
			close_on_exit = true,
			terminal_mappings = true,
			hide_numbers = true,
		}

		require("toggleterm").setup(default_terminal_opts)
		----------

		-- Terminal Apps
		-----------------

		-- Vars
		----------
		local Terminal = require("toggleterm.terminal").Terminal
		----------

		-- Basic Terminal
		----------
		local standard_term = Terminal:new({
			cmd = "/bin/bash",
			dir = fn.getcwd(),
			direction = "float",
			on_open = function()
				cmd([[ TermExec cmd="source ~/.bashrc &&  clear" ]])
			end,
			on_exit = function()
				cmd([[silent! ! unset HIGHER_TERM_CALLED ]])
			end,
		})
		function Standard_term_toggle()
			standard_term:toggle()
		end

		----------

		-- Docker - w/Lazydocker
		----------
		-- DockerCmd
		local docker_tui = "lazydocker"
		-- Setup
		local docker_client = Terminal:new({
			cmd = docker_tui,
			dir = fn.getcwd(),
			hidden = true,
			direction = "float",
			float_opts = {
				border = "double",
			},
		})
		-- toggle function
		function Docker_term_toggle()
			docker_client:toggle()
		end

		----------

		--  Git-UI - with Gitui
		----------
		-- GituiCmd
		local gitui = "gitui"
		-- Setup
		local gitui_client = Terminal:new({
			cmd = gitui,
			dir = fn.getcwd(),
			hidden = true,
			direction = "float",
			float_opts = {
				border = "double",
			},
		})

		-- toggle function
		function Gitui_term_toggle()
			gitui_client:toggle()
		end

		----------

		-- Mappings
		----------
		-- General
		keymap.set(
			"t",
			"<leader>q",
			"<CR>exit<CR><CR>",
			{ noremap = true, silent = true, desc = "Quit Terminal Instance" }
		)
		keymap.set("t", "<Esc>", "<c-\\><c-n>", { noremap = true, silent = true, desc = "Change to N mode" })
		keymap.set(
			"t",
			"vim",
			"say \"You're already in vim! You're a dumb ass!\"",
			{ noremap = true, silent = true, desc = "Stop you from inceptioning vim" }
		)
		keymap.set(
			"t",
			"editvim",
			'say "You\'re already in vim! This is why no one loves you!"',
			{ noremap = true, silent = true, desc = "Stop you from inceptioning vim" }
		)
		-- Standard Term Toggle
		nmap(lk.terminal.key .. "t", "lua Standard_term_toggle()", "Toggle Terminal")
		-- Docker Toggle
		nmap(lk.terminal.key .. "d", "lua Docker_term_toggle()", "Open Docker Container Management")
		-- Gitui Toggle
		nmap(lk.terminal.key .. "g", "lua Gitui_term_toggle()", "Open Git Ui")
		----------
	end,
}
