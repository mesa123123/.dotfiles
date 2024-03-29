--------------------------------
-- ######################  --
-- #  Main Nvim Config  #  --
-- ######################  --
--------------------------------

--------------------------------
-- TODOs
--------------------------------
-- NONE

--------------------------------
-- Priority Settings
--------------------------------
-- Set the config path
vim.g["config_path"] = "~/.config/nvim"
-- Set the mapleader
vim.g["mapleader"] = "\\"

--------------------------------
-- Configure Doc Commands
--------------------------------

-- Commands for Editing Docs
----------
vim.api.nvim_create_user_command("Editvim", "e ~/.config/nvim/init.lua", {})
vim.api.nvim_create_user_command("Editpackagesetup", "e ~/.config/nvim/package_setup.lua", {})
vim.api.nvim_create_user_command("Editplugins", "e ~/.config/nvim/lua/plugins.lua", {})
vim.api.nvim_create_user_command("Editleadermaps", "e ~/.config/nvim/lua/leader_mappings.lua", {})
vim.api.nvim_create_user_command("Editlsp", "e ~/.config/nvim/lua/lsp.lua", {})
vim.api.nvim_create_user_command("Editnotebooks", "e ~/.config/nvim/lua/notebooks.lua", {})
vim.api.nvim_create_user_command("Editdashboard", "e ~/.config/nvim/lua/dashboard.lua", {})
vim.api.nvim_create_user_command("Srcvim", "luafile ~/.config/nvim/init.lua", {})
----------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
local cmd = vim.cmd
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local ft = vim.filetype
local hl = vim.api.nvim_set_hl
local diagnostic = vim.diagnostic
local opt = vim.opt
local gv = vim.g
----------

-- Requires
----------
-- Modules
local ufuncs = require("personal_utils")
-- Scripts
require("package_setup")
require("notebooks")
require("lsp")
----------

-- Extra Vars
----------
local nmap = ufuncs.norm_keyset
local keyopts = ufuncs.keyopts
local nlmap = ufuncs.norm_loudkeyset
local get_python_path = ufuncs.get_python_path
----------

-------------------------------
-- Filetype Settings
-------------------------------

-- Custom Filetypes
----------
gv["do_filetype_lua"] = 1
gv["did_load_filetypes"] = 0
ft.add({
	filename = {
		["Vagrantfile"] = "ruby",
		["Jenkinsfile"] = "groovy",
	},
	pattern = { [".*req.*.txt"] = "requirements" },
	extension = { hcl = "ini", draft = "markdown", env = "config", jinja = "jinja", vy = "python", qmd = "markdown" },
})
----------

-- Tabs and Shiftwidth
----------
api.nvim_create_augroup("ShiftAndTabWidth", {})
-- Autocommand for shifts and tabs
local function set_shift_and_tab(length, patterns)
	api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
		pattern = patterns,
		callback = function()
			vim.bo.tabstop = length
			vim.bo.shiftwidth = length
			vim.bo.expandtab = true
		end,
		group = "ShiftAndTabWidth",
	})
end
-- Set them for various File extensions
set_shift_and_tab(2, { "*.md", "*.draft", "*.lua" })
set_shift_and_tab(4, { "*.py" })

-- Filetype specific autocommands
api.nvim_create_augroup("FileSpecs", {})
api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		local buftype = ft.match({ buf = 0 })
		if buftype == "gitcommit" then
			vim.bo.EditorConfig_disable = 1
		end
		if buftype == "markdown" then
			vim.wo.spell = true
			vim.bo.spelllang = "en_gb"
			vim.keymap.set("i", "<TAB>", "<C-t>", {})
		end
		if buftype == "yaml" then
			vim.wo.spell = true
			vim.bo.spelllang = "en_gb"
			vim.keymap.set("i", "<TAB>", "<C-t>", {})
		end
	end,
	group = "FileSpecs",
})
----------

--------------------------------
-- Editor Options, Settings, Commands
--------------------------------

-- Options
----------
-- Line Numbers On
opt.number = true
-- Other Encoding and Formatting settings
opt.linebreak = true
opt.autoindent = true
opt.encoding = "UTF-8"
opt.showmode = false
opt.splitbelow = true
opt.signcolumn = "yes"
-- Default Tabstop & Shiftwidth
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
-- Conceal Level
opt.conceallevel = 1
-- Mouse off
opt.mouse = ""
-- Spell Check On
opt.spell = true
-- toggle spellcheck
api.nvim_create_user_command("SpellCheckToggle", function()
	vim.opt.spell = not (vim.opt.spell:get())
end, { nargs = 0 })
-- Settings
------------
gv["EditorConfig_exclude_patterns"] = { "fugitive://.*", "scp://.*" }
-- Virtual Text Enabled Globally
diagnostic.config({
	virtual_text = true,
	underline = true,
	signs = true,
})
------------

-- AutoCmds
----------
-- Create Group
api.nvim_create_augroup("onYank", { clear = true })
-- Highlight on Yank
api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = "onYank",
	callback = function()
		vim.highlight.on_yank()
	end,
})
----------

--------------------------------
-- Code Folding - pretty-fold.nvim
--------------------------------

-- Theming Pretty Fold
----------
require("pretty-fold").setup({})
----------

-- Default Folding Options
----------
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.vim.treesitter.foldtext()"
opt.foldlevelstart = 99
----------

--------------------------------
-- Register Settings (Copy, Paste)
--------------------------------

-- Setup Config for xfce4 desktops to use system keyboard
----------
gv["clipboard"] = {
	name = "xclip-xfce4-clipman",
	copy = {
		["+"] = "xclip -selection clipboard",
		["*"] = "xclip -selection clipboard",
	},
	paste = {
		["+"] = "xclip -selection clipboard -o",
		["*"] = "xclip -selection clipboard -o",
	},
	cache_enabled = true,
}
----------

--------------------------------
-- Color Schemes and Themes
--------------------------------

-- Set & Customize Colour Scheme
----------
local gruvbox = require("gruvbox")
local palette = require("gruvbox").palette
gruvbox.setup({
	contrast = "hard",
	transparent_mode = false,
	italic = {
		strings = true,
		emphasis = true,
		comments = true,
		operators = false,
		folds = true,
	},
	overrides = {
		SignColumn = { bg = palette.dark0_hard },
	},
})
cmd("colorscheme gruvbox")
----------

-- Rainbow Brackets Options
----------
gv["rainbow_active"] = 1
----------
----------
local devIcons = require("nvim-web-devicons")
devIcons.setup({
	default = true,
	-- CustomFileTypes
	override_by_filename = {
		["requirements.txt"] = {
			icon = "",
			color = palette.bright_blue,
			cterm_color = "196",
			name = "requirements",
		},
		["dev-requirements.txt"] = {
			icon = "",
			color = palette.bright_blue,
			cterm_color = "196",
			name = "requirements",
		},
	},
})
-- Setup Custom Icons
devIcons.set_icon({
	htmldjango = {
		icon = "",
		color = palette.bright_red,
		cterm_color = "196",
		name = "Htmldjango",
	},
	jinja = {
		icon = "",
		color = palette.bright_red,
		cterm_color = "196",
		name = "Jinja",
	},
	rst = {
		icon = "",
		color = palette.bright_green,
		cterm_color = "lime green",
		name = "rst",
	},
})
devIcons.get_icons()
----------

-- Status Line Settings
----------
opt.laststatus = 2
----------

-- Highlighting
---------
-- SignColumn Transparency
hl(0, "SignColumn", { bg = palette.dark0_hard })
-- Lsp Underline
hl(0, "LspticsUnderlineError", { bg = palette.dark0_hard, fg = palette.bright_red, underline = true, blend = 50 })
hl(0, "LspticsUnderlineWarning", { bg = palette.dark0_hard, fg = palette.bright_yellow, underline = true, blend = 50 })
hl(
	0,
	"LspticsUnderlineInformation",
	{ bg = palette.dark0_hard, fg = palette.bright_blue, underline = true, blend = 50 }
)
hl(0, "LspticsUnderlineHint", { bg = palette.dark0_hard, fg = palette.bright_green, underline = true, blend = 50 })
-- Transparent Sign Column
hl(0, "DiagnosticSignOk", { fg = palette.bright_green, bg = palette.dark0_hard })
hl(0, "DiagnosticSignInfo", { fg = palette.bright_blue, bg = palette.dark0_hard })
hl(0, "DiagnosticSignWarn", { fg = palette.bright_yellow, bg = palette.dark0_hard })
hl(0, "DiagnosticSignError", { fg = palette.bright_blue, bg = palette.dark0_hard })
-- CmdLine Borders Etc.
hl(0, "NoiceCmdlinePopup", { fg = palette.neutral_blue, bg = palette.dark0_hard })
hl(0, "NoiceCmdlinePopupBorder", { bg = palette.dark0_hard })
----------

-- Highlight Colors as their Color
----------
require("colorizer").setup()
----------

-----------------------------
-- Start Page - startup.nvim
-----------------------------

local dashboard_config = require("dashboard")
-- Load Config
----------
require("startup").setup(dashboard_config)

----------

-------------------------------
-- Neovim Extender Plug-ins
-------------------------------

--Neodev
local neodev = require("neodev")
neodev.setup({
	library = { plugins = { "neotest" }, types = true },
})
----------

-----------------------------------------
-- Leader Remappings, Plugin Commands
-----------------------------------------

-- Commands
----------
api.nvim_create_user_command("Editleaderkeys", "e ~/.config/nvim/lua/leader_mappings.lua", {})
----------

-- Load Leader Keybinds
----------
lm = require("leader_mappings")
----------

-- Register Assist Menus
----------
local whichKey = require("which-key")
whichKey.register(lm.assistDesc)
---------

-- Mappings
---------------
nmap(lm.assist, "WhichKey", "Editor Mapping Assistance")
---------------

----------------------------------
-- Editor Mappings
----------------------------------

-- Autocorrect Mappings
----------
-- Create Edit Command
api.nvim_create_user_command("Editautocorrect", "e ~/.config/nvim/lua/autocorrect.lua", {})
-- Load File
require("autocorrect")
----------

-- Writing Mappings
----------
-- Redo set to uppercase U
keymap.set("n", "U", ":redo<CR>", keyopts({ desc = "Redo" }))
-- Remap Tabbing Rules, helps for typed languages <> becomes really annoying to type
keymap.set("i", "<c-.>", "<c-t>", {})
keymap.set("i", "<c-,>", "<c-d>", {})
keymap.set("n", "<c-.>", ">>", {})
keymap.set("n", "<c-,>", "<<", {})
----------

-- Screen Navigation Mappings
----------
-- Lazier Screen/Line Jumping
keymap.set({ "n", "v" }, "K", "H", {})
keymap.set({ "n", "v" }, "J", "L", {})
keymap.set({ "n", "v" }, "H", "0", {})
keymap.set({ "n", "v" }, "L", "$", {})
-- Remap what the last commands unmapped
keymap.set("n", "0", "K", {})
keymap.set("n", "$", "J", {})
-- Remap/Yank for delete too -_-
keymap.set("n", "dL", "d$", {})
keymap.set("n", "dH", "d0", {})
keymap.set("n", "yH", "y0", {})
keymap.set("n", "yL", "y$", {})
-- Search in Visual Mode
keymap.set("v", "<leader>/", '"fy/\\V<C-R>f<CR>', {})

-- Paste, Yank, Quit, Save Mappings
----------
-- Set Write/Quit to shortcuts
nlmap(lm.write .. "w", "w", "Write")
nlmap(lm.write .. "!", "w!", "Over-Write")
nlmap(lm.write .. "s", "so", "Write and Source to Nvim")
nlmap(lm.write .. "a", "wa", "Write All")
nlmap(lm.write_quit .. "q", "wq", "Close Buffer")
nlmap(lm.write_quit .. "b", "w<CR>:bd", "Write and Close Buffer w/o Pane")
nlmap(lm.write_quit .. "a", "wqa", "Write All & Quit Nvim")
nlmap(lm.quit .. "q", "q", "Close Buffer and Pane")
nlmap(lm.quit .. "!", "q!", "Close Buffer Without Writing")
nlmap(lm.quit_all .. "a", "qa", "Quit Nvim")
nlmap(lm.quit_all .. "!", "<cmd>qa!<cr>", "Quit Nvim Without Writing")
nlmap(lm.quit_buffer .. "b", "bd", "Close Buffer w/o Pane")
nlmap(lm.quit_buffer .. "!", "bd", "Close Buffer w/o Pane")
-- System Copy Set to Mappings
keymap.set({ "n", "v" }, lm.yank .. "v", '"+y', keyopts({ desc = "System Copy" }))
keymap.set({ "n", "v" }, lm.yank .. "y", '"+yy', keyopts({ desc = "System Copy: Line" }))
keymap.set("n", lm.yank .. "G", '"+yG', keyopts({ desc = "System Copy: Rest of File" }))
keymap.set("n", lm.yank .. "%", '"+y%', keyopts({ desc = "System Copy: Whole of File" }))
-- System Paste Set to Mappings
keymap.set({ "n", "v" }, lm.paste, '"+p', keyopts({ desc = "System Paste" }))
---------

-- Highlighting Search Mappings
---------
-- Trigger Highlight Searching Automatically
nmap("<cr>", "nohlsearch", "")
keymap.set("n", "n", ":set hlsearch<CR>n", keyopts({}))
keymap.set("n", "N", ":set hlsearch<CR>N", keyopts({}))
---------

-- Pane Control Mappings
----------
-- Tmux Pane Resizing Terminal Mode
keymap.set({ "t", "i", "c", "n" }, lm.resize .. "j", "<c-\\><c-n>:res-5<CR>i", { desc = "Move Partition Down" })
keymap.set({ "t", "i", "c", "n" }, lm.resize .. "k", "<c-\\><c-n>:res+5<CR>i", { desc = "Move Partition Up" })
keymap.set(
	{ "t", "i", "c", "n" },
	lm.resize .. "h",
	"<c-\\><c-n>:vertical resize -5<CR>i",
	{ desc = "Move Partition Left" }
)
keymap.set(
	{ "t", "i", "c", "n" },
	lm.resize .. "l",
	"<c-\\><c-n>:vertical resize +5<CR>i",
	{ desc = "Move Partition Right" }
)
----------

-- Tab Control mappings
----------
-- Navigation
keymap.set({ "t", "i", "c", "n" }, lm.tab .. "H", ":tabfirst<cr>", { desc = "Tab First" })
keymap.set({ "t", "i", "c", "n" }, lm.tab .. "L", ":tablast<cr>", { desc = "Tab Last" })
keymap.set({ "t", "i", "c", "n" }, lm.tab .. "l", ":tabn<cr>", { desc = "Tab Next" })
keymap.set({ "t", "i", "c", "n" }, lm.tab .. "h", ":tabp<cr>", { desc = "Tab Previous" })
-- Close Current Tab
keymap.set({ "t", "i", "c", "n" }, lm.tab .. "q", ":tabc<cr>", { desc = "[Q]uit tab" })
-- Close alther Tabs
keymap.set({ "t", "i", "c", "n" }, lm.tab .. "o", ":tabo<cr>", { desc = "Tab Open" })
-- New Tab ote n is already used as a search text tool and cannot be mapped
keymap.set({ "t", "i", "c", "n" }, lm.tab .. "n", ":tabnew<cr>", { desc = "[N]ew Tab" })
----------

-- Buffer Control Mappings
----------
keymap.set("n", lm.file .. "l", "<cmd>bnext<CR>", { silent = true, desc = "Next Buff" })
keymap.set("n", lm.file .. "h", "<cmd>bprev<CR>", { silent = true, desc = "Prev Buff" })
----------

-- Scroll Control Mappings
----------
-- Super Charge up and down scroll
keymap.set({ "n", "v" }, "<C-e>", "5<c-e>", {})
keymap.set({ "n", "v" }, "<C-y>", "5<c-y>", {})
----------

-- Auto-Comment Mappings
----------
local auto_comment = require("Comment").setup()
----------

-----------------------------------------
--  Syntax Highlighting: Tree-Sitter Config
-----------------------------------------

local treesitter = vim.treesitter

-- Plugin Setup
----------
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"rust",
		"toml",
		"markdown",
		"markdown_inline",
		"html",
		"css",
		"htmldjango",
		"rst",
		"python",
		"bash",
		"vim",
		"go",
		"csv",
		"regex",
		"javascript",
		"typescript",
		"requirements",
		"jsonc",
		"latex",
		"http",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
	},
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown", "rst" },
	},
	ident = { enable = true },
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
		colors = {},
	},
	modules = {},
	sync_install = true,
	ignore_install = {},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},
})

-- Custom Filetypes
treesitter.language.register("htmldjango", "jinja")
----------

-- Mappings
----------
-- Context Bar - W/TS Context
nmap("<leader>hc", "TSContextEnable", "Context Highlight On")
nmap("<leader>hs", "TSContextDisable", "Context Highlight Off")
nmap("<leader>ht", "TSContextToggle", "Context Highlight Toggle")
nmap("[c", 'lua require(treesitter-context").go_to_context(vim.v.count1)', "Context Highlight Toggle")
----------

-----------------------------------------
-- Notification Settings - Notify.nvim
-----------------------------------------

local notify = require("notify")

-- Configuration
----------
notify.setup({
	render = "simple",
	timeout = 200,
	stages = "fade",
	minimum_width = 25,
	top_down = true,
})
-- Highlighting
hl(0, "NotifyBackground", { bg = palette.dark0_hard })
----------

--------------------------------
-- CmdLine Settings - Noice.nvim/Dressing.nvim
--------------------------------

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
      }
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

----------

-----------------------------
-- Window Line - barbecue
-----------------------------

-- Setup
----------
require("barbecue").setup()
----------

-----------------------------
-- Status Line - lualine
-----------------------------

----------
-- Helper Functions
----------

-- Get accurate time on panel
----------
function Zonedtime(hours)
	-- Change time zone here (default seems to be +12 on home workstation)
	local zone_difference = 11
	local t = os.time() - (zone_difference * 3600)
	local d = t + hours * 3600
	return os.date("%H:%M %Y-%m-%d", d)
end
----------

-- Truncate components on smaller windows
------------------
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
	return function(str)
		local win_width = vim.fn.winwidth(0)
		if hide_width and win_width < hide_width then
			return ""
		elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
			return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
		end
		return str
	end
end
------------------

-- Linting, Formatting, Lsp, Dap Info
------------------
-- LSP
local active_lsp = {
	function()
		local bufnr = vim.api.nvim_get_current_buf()
		local lsps = vim.lsp.get_active_clients({ bufnr })
		if lsps and #lsps > 0 then
			local names = {}
			for _, lsp in ipairs(lsps) do
				table.insert(names, lsp.name)
			end
			return string.format(" %s", table.concat(names, ", "))
		else
			return ""
		end
	end,
	color = { fg = palette.bright_red },
	fmt = trunc(120, 3, 90, true),
}
-- Formatter
local active_formatter = {
	function()
		local formatters = require("conform").list_formatters_for_buffer(0)
		if formatters ~= nil then
			return string.format(" %s", table.concat(formatters, ", "))
		else
			return ""
		end
	end,
	color = { fg = palette.bright_green },
	fmt = trunc(120, 3, 90, true),
}
-- Linter
local active_lint = {
	function()
		local linters = require("lint").linters_by_ft[vim.bo.filetype][1]
		if linters ~= nil then
			return string.format("󰯠 %s", linters)
		else
			return ""
		end
	end,
	color = { fg = palette.bright_yellow },
	fmt = trunc(120, 4, 90, true),
}
-- Debugger
local debug_status = {
	function()
		local status = require("dap").status()
		if status ~= "" then
			return string.format("󰃤 %s", status)
		else
			return ""
		end
	end,
	color = { fg = palette.dark_red },
	fmt = trunc(120, 4, 90, true),
}
------------------

-- Show if a macro is recording
------------------
local noice_recording = {
	function()
		local rec_status = vim.fn.reg_recording()
		if rec_status ~= "" then
			return string.format("󰑋 %s", string.sub(rec_status, string.len(rec_status)))
		else
			return ""
		end
	end,
	color = { fg = palette.dark0_hard },
}
------------------

-- Config
----------
require("lualine").setup({
	options = {
		section_separators = { left = " ", right = " " },
		component_separators = { left = "", right = "" },
		theme = "gruvbox-material",
	},
	sections = {
		lualine_a = { {
			"mode",
			fmt = function(res)
				return res:sub(1, 1)
			end,
		}, noice_recording },
		lualine_b = {
			"branch",
			{
				"diff",
				symbols = { added = "+", modified = "~", removed = "-" },
				fmt = trunc(120, 10000, 120, true),
			},
			{
				"diagnostics",
				symbols = { error = "", warn = "", info = "", hint = "" },
				fmt = trunc(120, 10000, 120, true),
			},
		},
		lualine_c = {
			{ "filetype", colored = true, icon_only = true, icon = { align = "right" }, fmt = trunc(120, 4, 90, true) },
			debug_status,
			{ "overseer", colored = true },
		},
		lualine_x = { active_lsp, active_lint, active_formatter },
		lualine_y = { { "progress", fmt = trunc(120, 10000, 120, true) }, { "location" } },
		lualine_z = { "Zonedtime(11)" },
	},
})
----------

----------------------------------
-- Terminal Settings: <leader>t & <leader>a - toggleterm
----------------------------------

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
keymap.set("t", "<leader>q", "<CR>exit<CR><CR>", { noremap = true, silent = true, desc = "Quit Terminal Instance" })
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
nmap(lm.terminal .. "t", "lua Standard_term_toggle()", "Toggle Terminal")
-- Docker Toggle
nmap(lm.terminal .. "d", "lua Docker_term_toggle()", "Open Docker Container Management")
-- Gitui Toggle
nmap(lm.terminal .. "g", "lua Gitui_term_toggle()", "Open Git Ui")
----------

---------------------------------
-- Functions Handled by Telescope
---------------------------------
-- Projects
-- File Tree
-- Buffer Management
-- Buffer Diff

-- Telescope Variables
----------
local tele_actions = require("telescope.actions")
----------

-----------------------------
-- Filetree: <c-n> - telescope-file-browser
-----------------------------

-- Functions
----------
local fb_actions = require("telescope._extensions.file_browser.actions")
----------

-- Config
----------
local file_browser_configs = {
	hijack_netrw = true,
	initial_mode = "insert",
	git_status = true,
	respect_gitignore = false,
	-- Internal Mappings
	----------
	mappings = {
		-- Normal Mode
		["n"] = {
			["<C-n>"] = tele_actions.close,
			["<A-c>"] = fb_actions.change_cwd,
			["h"] = fb_actions.goto_parent_dir,
			["l"] = require("telescope.actions.set").select,
			["c"] = fb_actions.goto_cwd,
			["<C-a>"] = fb_actions.create,
			["<A-h>"] = fb_actions.toggle_hidden,
		},
		-- Insert Mode
		["i"] = {
			["<C-n>"] = tele_actions.close,
			["<A-c>"] = fb_actions.change_cwd,
			["<C-h>"] = fb_actions.goto_parent_dir,
			["<C-l>"] = require("telescope.actions.set").select,
			["<C-j>"] = tele_actions.move_selection_next,
			["<C-k>"] = tele_actions.move_selection_previous,
			["<C-c>"] = fb_actions.goto_cwd,
			["<A-h>"] = fb_actions.toggle_hidden,
			["<C-a>"] = fb_actions.create,
		},
	},
}
----------

-- Mappings
----------
nmap(lm.ftree, "Telescope file_browser theme=dropdown", "Toggle File Browser")
----------

-----------------------------
-- Ui-Select Management: - Ui Improvements, not mapped to a keybinding
-----------------------------

-- Config
----------
local ui_select_configs = {}
----------

-----------------------------
-- Todo Highlighting: - <leader>m - TodoComments
-----------------------------

-- Config
----------
require("todo-comments").setup({
	keywords = {
		LOOKUP = { icon = "󱛉", color = "lookup" },
		TODO = { icon = "󰟃", color = "todo" },
		BUG = { icon = "󱗜", color = "JiraBug" },
		TASK = { icon = "", color = "JiraTask" },
	},
	colors = {
		lookup = { "#8800bb" },
		todo = { "#3080b0" },
		JiraBug = { "#e5493a" },
		JiraTask = { "#4bade8" },
	},
})
----------

-- Mappings
----------
keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, keyopts({ desc = "Next todo comment" }))

keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, keyopts({ desc = "Previous todo comment" }))

nmap(lm.todo, "TodoTelescope", "List Todos")
----------

---------------------------------
-- Buffer Management: <leader>f  - Telescope Core
---------------------------------

-- Mappings
----------
nmap(lm.file .. "b", "Telescope buffers theme=dropdown", "Show Buffers")
nmap("<C-b>s", "Telescope buffers theme=dropdown", "Show Buffers")
nmap(lm.file .. "c", "Telescope colorscheme theme=dropdown", "Themes")
nmap(lm.file .. "d", "Telescope diagnostics", "Diagnostics")
nmap(lm.file .. "f", "Telescope find_files theme=dropdown", "Find Files")
nmap(lm.file .. "g", "Telescope live_grep theme=dropdown", "Live Grep")
nmap(lm.file .. "H", "Telescope help_tags theme=dropdown", "Help Tags")
nmap(lm.file .. "i", "Telescope import theme=dropdown", "Imports")
nmap(lm.file .. "j", "Telescope jumplist theme=dropdown<CR>", "Jumplist")
nmap(lm.file .. "k", "Telescope keymaps theme=dropdown", "Keymaps")
nmap(lm.file .. "m", "Telescope man_pages theme=dropdown", "Man Pages")
nmap(lm.file .. "n", "Telescope notify", "Notifications")
nmap(lm.file .. "o", "Telescope vim_options theme=dropdown<CR>", "Vim Options")
nmap(lm.file .. "r", "Telescope registers theme=dropdown", "Registers")
nmap(lm.file .. "s", "Telescope treesitter theme=dropdown", "Treesitter Insights")
nmap(lm.file .. "t", "Telescope builtin theme=dropdown", "Telescope Commands")
----------

---------------------------------
-- Telescope Setup
---------------------------------

-- Local var
----------
local telescope = require("telescope")

-- Setup
----------
telescope.setup({
	pickers = {
		buffers = {
			mappings = {
				-- Redo this action so you can take a parameter that allows for force = true and force = false for unsaved files
				i = {
					["<a-d>"] = tele_actions.delete_buffer,
					["<c-k>"] = tele_actions.move_selection_previous,
					["<c-j>"] = tele_actions.move_selection_next,
					["<C-J>"] = tele_actions.preview_scrolling_down,
					["<C-K>"] = tele_actions.preview_scrolling_up,
					["<C-L>"] = tele_actions.preview_scrolling_right,
					["<C-H>"] = tele_actions.preview_scrolling_left,
				},
			},
		},
	},
	extensions = {
		file_browser = file_browser_configs,
		ui_select = ui_select_configs,
	},
})

-- Extension setup (must Go last)
telescope.load_extension("file_browser")
telescope.load_extension("import")
telescope.load_extension("ui-select")
----------

---------
-- End of Telescope Setup
---------

---------------------------------
-- Version Control Functionality: <leader>v - fugitive & Telescope
---------------------------------

-- Keymappings
------------------
keymap.set("n", "<leader>vw", "<cmd>G blame<CR>", { silent = true, desc = "Git Who? (Blame)" })
keymap.set("n", "<leader>vm", "<cmd>G mergetool<CR>", { silent = true, desc = "Git Mergetool" })
keymap.set("n", "<leader>va", "<cmd>Gwrite<CR>", { silent = true, desc = "Add Current File" })
keymap.set("n", "<leader>vc", ":Git commit -m ", { silent = true, desc = "Make a commit" })
-- Telescope Functions - git
----------
-- Commits
keymap.set(
	"n",
	"<leader>vfc",
	"<cmd>Telescope git_commits theme=dropdown theme=dropdown<cr>",
	{ silent = true, desc = "Git Commits" }
)
-- Status
keymap.set("n", "<leader>vfs", "<cmd>Telescope git_status theme=dropdown<cr>", { silent = true, desc = "Git Status" })
-- Branches
keymap.set(
	"n",
	"<leader>vfb",
	"<cmd>Telescope git_branches theme=dropdown<cr>",
	{ silent = true, desc = "Git Branches" }
)
-- Git Files
keymap.set("n", "<leader>vff", "<cmd>Telescope git_files theme=dropdown<cr>", { silent = true, desc = "Git Files" })
----------

---------
-- End of VC setup
---------

---------------------------------
-- Wiki Functionality: <leader>k - Obsidian.nvim
---------------------------------

-- Variables
----------
local obsidian = require("obsidian")
----------

-- Functions
----------
local make_note_id = function(title)
	local suffix = ""
	if title ~= nil then
		suffix = title:gsub(" ", "-")
	else
		suffix = tostring(os.time())
	end
	return suffix
end

local make_note_frontmatter = function(note)
	note:add_tag("TODO")
	local out = { id = note.id, aliases = note.aliases, tags = note.tags }
	if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
		for k, v in pairs(note.metadata) do
			out[k] = v
		end
	end
	return out
end

-- Setup
----------
obsidian.setup({
	dir = "~/Learning",
	templates = {
		subdir = "templates",
		date_format = "%Y-%m-%d-%a",
		time_format = "%H:%M",
	},
	mappings = {},
	note_id_func = make_note_id,
	note_frontmatter_func = make_note_frontmatter,
})
----------

-- Mappings
----------
-- Normal Mode
nmap(lm.wiki .. "b", "ObsidianBacklinks", "Get References To Current")
nmap(lm.wiki .. "t", "ObsidianToday", "Open (New) Daily Note")
nmap(lm.wiki .. "y", "ObsidianYesterday", "Create New Daily Note For Yesterday")
nmap(lm.wiki .. "o", "ObsidianOpen", "Open in Obisidian App")
nmap(lm.wiki .. "s", "ObsidianSearch", "Search Vault Notes")
nmap(lm.wiki .. "q", "ObsidianQuickSwitch", "Note Quick Switch")
nmap(lm.wiki_linkOpts .. "l", "ObsidianFollowLink", "Go To Link Under Cursor")
nmap(lm.wiki_linkOpts .. "t", "ObsidianTemplate", "Insert Template Into Link")
keymap.set("n", lm.wiki_createPage .. "n", ":ObsidianNew ", { silent = false, desc = "Create New Note" })
-- Visual Mode
keymap.set("v", lm.wiki_createPage .. "l", ":ObsidianLinkNew ", { silent = false, desc = "Created New Linked Note" })
keymap.set("v", lm.wiki_linkOpts .. "a", "<cmd>ObsidianLink<cr>", { silent = true, desc = "Link Note To Selection" })
-----------

---------------------------------
-- Latex Functionality: <leader>l - Vimtex
---------------------------------

-- Setup (Currently not supported in Lua)

api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.tex" },
	callback = function()
		vim.g["vimtext_view_method"] = "zathura"
	end,
})
---------------------------------
-- Code Align
---------------------------------

-- Mappings
----------
-- Start interactive EasyAlign in visual mode (e.g. vipga)
keymap.set("x", lm.codeAction_alignment, "<Plug>(EasyAlign)<CR>", { desc = "Easy Align" })
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
keymap.set("n", lm.codeAction_alignment, "<Plug>(EasyAlign)<CR>", { desc = "Easy Align" })
----------

---------------------------------"
-- Database Commands - DadBod
---------------------------------"

-- Options
---------
gv["db_ui_save_location"] = "~/.config/db_ui"
gv["dd_ui_use_nerd_fonts"] = 1
----------

-- Mappings
---------
nmap(lm.database .. "u", "DBUIToggle<CR>", "Toggle DB UI")
nmap(lm.database .. "f", "DBUIFindBuffer<CR>", "Find DB Buffer")
nmap(lm.database .. "r", "DBUIRenameBuffer<CR>", "Rename DB Buffer")
nmap(lm.database .. "l", "DBUILastQueryInfo<CR>", "Run Last Query")
---------

---------------------------------"
-- Code Execution - compiler.nvim, overseer, vimtext
---------------------------------"

-- Mappings
----------
api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		if vim.bo.filetype == "tex" then
			vim.keymap.set(
				"n",
				require("leader_mappings").exec .. "x",
				"<cmd>VimtexCompile<CR>",
				{ silent = true, noremap = false, desc = "Compile Doc" }
			)
		else
			vim.keymap.set(
				"n",
				require("leader_mappings").exec .. "x",
				"<cmd>CompilerOpen<CR>",
				{ silent = true, noremap = false, desc = "Run Code" }
			)
		end
	end,
})
nmap(lm.exec .. "q", "CompilerStop", "Stop Code Runner")
nmap(lm.exec .. "i", "CompilerToggleResults", "Show Code Run")
nmap(lm.exec .. "r", "CompilerStop<cr>" .. "<cmd>CompilerRedo", "Re-Run Code")
----------

---------------------------------"
-- Http Execution - rest.nvim
---------------------------------"

nmap(lm.exec_http .. "x", "RestNvim", "Run Http Under Cursor")
nmap(lm.exec_http .. "p", "RestNvimPreview", "Preview Curl Command From Http Under Cursor")
nmap(lm.exec_http .. "x", "RestNvim", "Re-Run Last Http Command")

---------------------------------"
-- Code Testing - neotest
---------------------------------"

-- Setup Test Runners
----------

-- Setup
----------
-- Neotest
require("neotest").setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = false },
			runner = "pytest",
			python = get_python_path(),
			pytest_discover_instances = true,
		}),
		-- Currently broken
		-- {
		-- 	require("neotest-rust")({
		-- 		args = { "--no-capture" },
		-- 		dap_adapter = "lldb",
		-- 	}),
		-- },
	},
	status = {
		enabled = true,
		virtual_text = true,
		signs = false,
	},
})
----------

-- Mappings
----------
-- Mappings
nmap(lm.exec_test .. "x", "lua require('neotest').run.run(vim.fn.expand('%'))", "Test Current Buffer")
nmap(lm.exec_test .. "o", "lua require('neotest').output.open({ enter = true, auto_close = true })", "Test Output")
nmap(lm.exec_test .. "s", "lua require('neotest').summary.toggle()", "Test Output (All Tests)")
nmap(lm.exec_test .. "q", "lua require('neotest').run.stop()", "Quit Test Run")
nmap(lm.exec_test .. "w", "lua require('neotest').watch.toggle(vim.fn.expand('%'))", "Toggle Test Refreshing")
nmap(lm.exec_test .. "c", "lua require('neotest').run.run()", "Run Nearest Test")
nmap(lm.exec_test .. "r", "lua require('neotest').run.run_last()", "Repeat Last Test Run")
nmap(
	lm.exec_test .. "b",
	"lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})",
	"Debug Closest Test"
)
----------

---------------------------------"
-- Code Coverage
---------------------------------"
require("coverage").setup({
	commands = true, -- create commands
	highlights = {
		-- customize highlight groups created by the plugin
		covered = { fg = palette.bright_green }, -- supports style, fg, bg, sp (see :h highlight-gui)
		uncovered = { fg = palette.bright_red },
	},
	signs = {
		-- use your own highlight groups or text markers
		covered = { hl = "CoverageCovered", text = "▎" },
		uncovered = { hl = "CoverageUncovered", text = "▎" },
	},
	summary = {
		-- customize the summary pop-up
		min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
	},
	lang = {
		-- customize language specific settings
	},
})

-- Mappings
----------
nmap(lm.exec_test_coverage .. "r", "Coverage", "Run Coverage Report")
nmap(lm.exec_test_coverage .. "s", "CoverageSummary", "Show Coverage Report")
nmap(lm.exec_test_coverage .. "t", "CoverageToggle", "Toggle Coverage Signs")
----------

--------------------------------
-- Workspace Specific Configs
--------------------------------

-- Allow WorkSpace Specific Init
-- if filereadable("./ws_init.lua")
--     luafile ./ws_init.lua
-- endif

--------------------------------
-- EOF
-------------------------------
