--------------------------------
-- ######################  --
-- #  Dashboard Config  #  --
-- ######################  --
--------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
local hl = vim.api.nvim_set_hl
----------

-- Requires
----------
local palette = require("core.colors").palette
----------

-- Define Highlight
----------
hl(0, "DashboardTitle", { fg = palette.light2 })
hl(0, "DashboardMappings", { fg = palette.light3 })
----------

-- Sections Defn
----------
local title_line = {
	type = "text",
	margin = 0,
	content = {
		" _____                                                                                                   _____  ",
		"(_____)                                                                                                 (_____) ",
		" |███|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|███|  ",
		" |███|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|███|  ",
		" |███|                                                                                                   |███|  ",
		" |███|                                                                                                   |███|  ",
		" |███|   ██╗  ██╗██╗ █████╗      ██████╗ ██████╗  █████╗        ████████╗███████╗     █████╗  ██████╗    |███|  ",
		" |███|   ██║ ██╔╝██║██╔══██╗    ██╔═══██╗██╔══██╗██╔══██╗       ╚══██╔══╝██╔════╝    ██╔══██╗██╔═══██╗   |███|  ",
		" |███|   █████╔╝ ██║███████║    ██║   ██║██████╔╝███████║          ██║   █████╗      ███████║██║   ██║   |███|  ",
		" |███|   ██╔═██╗ ██║██╔══██║    ██║   ██║██╔══██╗██╔══██║          ██║   ██╔══╝      ██╔══██║██║   ██║   |███|  ",
		" |███|   ██║  ██╗██║██║  ██║    ╚██████╔╝██║  ██║██║  ██║▄█╗       ██║   ███████╗    ██║  ██║╚██████╔╝   |███|  ",
		" |███|   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝       ╚═╝   ╚══════╝    ╚═╝  ╚═╝ ╚═════╝    |███|  ",
		" |███|                                                                                                   |███|  ",
		" |███|                                                                                                   |███|  ",
		" |███|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|███|  ",
		" |███|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|███|  ",
		"(_____)                                                                                                 (_____) ",
	},
	align = "center",
	highlight = "DashboardTitle",
}

local mappings = {
	type = "mapping",
	align = "center",
	content = {
		{ " File Explorer", ":Telescope file_browser<CR>", "n" },
		{ " Editvim", "Editvim", "v" },
		{ "󰚥 Editplugins", "Editplugins", "p" },
		{ "󰌌 Editleaderkeys", "Editleaderkeys", "l" },
		{ " Editlsp", "Editlsp", "l" },
		{ "󱜤 EditDashboard", "Editdashboard", "d" },
		{ "󰠮 EditNotebooks", "Editnotebooks", "b" },
		{ "󱌣 EditUtils", "Editutils", "u" },
	},
	margin = 0,
	highlight = "DashboardMappings",
}

return {
	title_line = title_line,
	mappings = mappings,
	colors = {
		background = palette.dark0_hard,
	},
	empty_lines_between_mappings = false,
  disable_statuslines = true,
	options = {},
	parts = { "title_line", "mappings" },
}

----------
