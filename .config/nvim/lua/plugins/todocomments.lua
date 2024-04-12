return {
	{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, event = "VeryLazy" },
	{ "numToStr/Comment.nvim", lazy = false },
	config = function()
		local lk = require("core.keymaps").lk
        local palette = require('core.theme').palette
		local keyopts = require("core.utils").keyopts
		local nmap = require("core.utils").norm_keyset
		require("todo-comments").setup({
			keywords = {
				LOOKUP = { icon = "󱛉", color = "lookup" },
				TODO = { icon = "󰟃", color = "todo" },
				BUG = { icon = "󱗜", color = "JiraBug" },
				TASK = { icon = "", color = "JiraTask" },
			},
			colors = {
				lookup = { palette.faded_purple },
				todo = { palette.netural_blue },
				JiraBug = { palette.bright_red },
				JiraTask = { palette.bright_blue },
			},
		})
		----------

		-- Mappings
		----------
		vim.keymap.set("n", "]t", function()
			require("todo-comments").jump_next()
		end, keyopts({ desc = "Next todo comment" }))

		vim.keymap.set("n", "[t", function()
			require("todo-comments").jump_prev()
		end, keyopts({ desc = "Previous todo comment" }))

		nmap(lk.todo.key, "TodoTelescope", "List Todos")
		----------
	end,
}
