return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		--------------------------------
		-- CmdLine Settings - Noice.nvim/Dressing.nvim
		--------------------------------
		local keyopts = require("core.utils").keyopts
		local keymap = vim.keymap
		-- Config
		----------
		require("noice").setup({
			views = {
				cmdline_popup = {
					border = {
						style = "rounded",
					},
					position = {
						row = 5,
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
				},
				win_options = {
					winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
				},
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				progress = {
					enabled = true,
					view = "mini",
					throttle = 1000,
				},
				"requirements",
				signature = {
					enabled = false,
				},
				hover = {
					enabled = false,
				},
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		})
		----------

		-- Mappings
		----------
		keymap.set("n", "<leader>:", ":lua print(", keyopts({ desc = "Print Lua Command" }))
		keymap.set("n", "<leader>;", ":h ", keyopts({ desc = "Open Help Reference" }))
		keymap.set("n", "<leader>!", ":! ", keyopts({ desc = "Run System Command" }))
	end,
}
