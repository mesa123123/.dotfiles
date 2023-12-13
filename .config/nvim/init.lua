--------------------------
-- ###################  --
-- # Main Vim Config #  --
-- ###################  --
--------------------------

--------------------------------
-- TO DO
--------------------------------
-- None
----------------------------------

-------------------------------
-- Priority Settings
--------------------------------
-- Set the config path
vim.g["config_path"] = "~/.config/nvim"
-- Set the mapleader
vim.g["mapleader"] = "\\"

--------------------------------
-- Luaisms for Vim Stuff
--------------------------------

-- Variables
----------
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local keymap = vim.keymap
local hl = api.nvim_set_hl
local loop = vim.loop
-- For Options
local opt = vim.opt -- vim options
local gopt = vim.go -- global options
local bopt = vim.bo -- buffer options
local wopt = vim.wo -- window options
-- For Variables
local g = vim.g -- global variables
local b = vim.b -- buffer variables
local w = vim.w -- window variables
----------

-- Functions
----------

-- ex (Currently this is a wrapper for everything not yet implemented in nvim)
local ex = setmetatable({}, {
	__index = function(t, k)
		local command = k:gsub("_$", "!")
		local f = function(...)
			return api.nvim_cmd(table.concat(vim.tbl_flatten({ command, ... }), " "))
		end
		rawset(t, k, f)
		return f
	end,
})

-- Map(function, table)
function Map(func, tbl)
	local newtbl = {}
	for i, v in pairs(tbl) do
		newtbl[i] = func(v)
	end
	return newtbl
end

-- Filter(function, table)
function Filter(func, tbl)
	local newtbl = {}
	for i, v in pairs(tbl) do
		if func(v) then
			newtbl[i] = v
		end
	end
	return newtbl
end

-- Concat two Tables
----------
local function tableConcat(t1, t2)
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
	return t1
end

----------

--------------------------------
-- Plugin Loading and Settings -- lazy.nvim
--------------------------------

-- Install
----------
-- Download
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not loop.fs_stat(lazypath) then
	fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
-- Add to Runtime Path
opt.rtp:prepend(lazypath)
----------

-- Setup
----------------
local plugins = {
	-- Essentials
	----------
	"nvim-lua/plenary.nvim",
	"nvim-treesitter/nvim-treesitter",
	"folke/neodev.nvim",
	-- Autocompletion & Snips
	----------
	{
		"hrsh7th/nvim-cmp",
		-- Extensions for NvimCmp
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"ray-x/cmp-treesitter",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
			"rcarriga/nvim-notify",
		},
	},
	-- Language Server Protocol
	----------
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"williamboman/mason.nvim",
			"ray-x/lsp_signature.nvim",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	},
	{ "jose-elias-alvarez/null-ls.nvim", branch = "main" },
	-- Linting Plugins
	----------
	"mfussenegger/nvim-lint",
	-- Formatting
	----------
	"stevearc/conform.nvim",
	-- Debug Adapter Protocol
	----------
	"mfussenegger/nvim-dap",
	"rcarriga/nvim-dap-ui",
	-- Assitance Plugins
	----------
	"folke/which-key.nvim",
	{ "numToStr/Comment.nvim", lazy = false },
	-- Testing Plugins
	----------
	"antoinemadec/FixCursorHold.nvim",
	"nvim-neotest/neotest",
	"nvim-neotest/neotest-python",
	"tpope/vim-cucumber",
	-- Database Workbench,
	-----------
	"tpope/vim-dadbod",
	"kristijanhusak/vim-dadbod-ui",
	-- File System and Plugins
	----------
	"yggdroot/indentline",
	"tpope/vim-fugitive",
	"editorconfig/editorconfig-vim",
	-- Status Bar
	------------
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
	},
	------------
	-- Colors and Themes
	------------
	"altercation/vim-colors-solarized",
	"nvie/vim-flake8",
	-- DevIcons
	"nvim-tree/nvim-web-devicons",
	-- Theme
	"ellisonleao/gruvbox.nvim",
	-- Brackets Rainbowing
	"luochen1990/rainbow",
	-- Rainbow csv hl
	{
		"cameron-wags/rainbow_csv.nvim",
		config = true,
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
		cmd = {
			"RainbowDelim",
			"RainbowDelimSimple",
			"RainbowDelimQuoted",
			"RainbowMultiDelim",
		},
	},
	-- Git Highlighting
	"itchyny/vim-gitbranch",
	-- Color Highlighting
	"norcalli/nvim-colorizer.lua",
	-- LSP Icons
	"onsails/lspkind.nvim",
	-- Dashboard
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- CmdLine
	----------
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
    "stevearc/dressing.nvim",
	----------
	-- Nvim Telescope
	---------
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"BurntSushi/ripgrep",
			"sharkdp/fd",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-telescope/telescope-project.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"piersolenski/telescope-import.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
	},
	----------
	-- Study Functionality
	----------
	-- Wiki - Obsidian nvim
	{ "epwalsh/obsidian.nvim" },
	----------
	-- Alignment
	"junegunn/vim-easy-align",
	-- HardMode
	"takac/vim-hardtime",
	-- Working with Kitty
	{ "fladson/vim-kitty", branch = "main" },
	-- Terminal Behaviour
	{ "akinsho/toggleterm.nvim", version = "v2.*" },
}
-- Plugin Options
local pluginOpts = {}
-- Load
require("lazy").setup(plugins, pluginOpts)
----------

--------------------------------
-- Configure Vimrc from Vim
--------------------------------

-- Commands
----------
api.nvim_create_user_command("Editvim", "e ~/.config/nvim/init.lua", {}) -- Edit Config
api.nvim_create_user_command("Srcv", "luafile ~/.config/nvim/init.lua", {}) -- Source Config
----------

--------------------------------
-- Color Schemes and Themes
--------------------------------

-- Set TermGuiColors true
----------
opt.termguicolors = true

-- Load Color Scheme
----------
require("gruvbox").setup({ contrast = "hard" })
cmd("colorscheme gruvbox")
----------

-- Rainbow Brackets Options
----------
g["rainbow_active"] = 1
----------

-- Colorize Colors
---------
require("colorizer").setup()

-- Load Webdevicons
----------
local devIcons = require("nvim-web-devicons")
devIcons.setup({ default = true })
-- Setup Custom Icons
devIcons.set_icon({
	htmldjango = {
		icon = "",
		color = "#e44d26",
		cterm_color = "196",
		name = "Htmldjango",
	},
	jinja = {
		icon = "",
		color = "#e44d26",
		cterm_color = "196",
		name = "Jinja",
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
hl(0, "LspDiagnosticsUnderlineError", { bg = "#EB4917", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineWarning", { bg = "#EBA217", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineInformation", { bg = "#17D6EB", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineHint", { bg = "#17EB7A", underline = true, blend = 50 })
----------

--------------------------------
-- Editor Options, Settings, Commands
--------------------------------

-- Options
----------
-- Line Numbers On
opt.number = true
-- Other Enconding and Formatting settings
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
-- Folding Options
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99
----------

-- Settings
----------
g["EditorConfig_exclude_patterns"] = { "fugitive://.*", "scp://.*" }
----------

-- Commands
----------
cmd([[ au FileType gitcommit let b:EditorConfig_disable = 1 ]])
cmd([[ set mouse= ]])
----------

-- Setup Config for xfce4 desktops to use system keyboard
----------
g["clipboard"] = {
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

-------------------------------
-- Neovim Extender Plugings
-------------------------------

--Neodev
local neodev = require("neodev")
neodev.setup({
	library = { plugins = { "nvim-dap-ui" }, types = true },
})
----------

-------------------------------
-- Language Specific Settings
-------------------------------

-- Filetype Enable
-----------
cmd([[ filetype on ]])
cmd([[ filetype plugin indent on ]])
----------

-- FileTypes
----------
cmd([[ au FileType cpp setlocal et ts=2 sw=2 ]]) -- C++ Language
cmd([[ au BufRead,BufNewFile *.hcl set filetype=ini ]]) -- HCL Language
cmd([[ au BufNewFile,BufRead Jenkinsfile set filetype=groovy ]]) -- JenkinsFile
cmd([[ au FileType python setlocal et ts=4 sw=4 sts=4 ]]) -- Python Language
cmd([[ au FileType typescript setlocal ts=2 sw=2 sts=2 ]]) -- Typescript Settings
cmd([[ au BufRead,BufNewFile Vagrantfile set filetype=ruby ]]) -- Vagrant Files
----------

-- Markdown
---------
-- Set certain types to markdown
cmd([[ au BufRead,BufNewFile *.draft set filetype=markdown ]])
cmd([[ au BufRead,BufNewFile *.md set filetype=markdown ]])
-- Config
cmd([[ au FileType markdown setlocal ts=2 sw=2 sts=2 ]])
cmd([[ au FileType markdown setlocal spell spelllang=en_gb ]])
cmd([[ au FileType markdown inoremap <TAB> <C-t> ]])
-- Markdown Syntax Highlighting
g["vim_markdown_fenced_languages"] = [['csharp=cs', 'json=javascript', 'mermaid=mermaid']]
g["vim_markdown_folding_disabled"] = 1
g["vim_markdown_conceal_code_blocks"] = 0
g["vim_markdown_conceal"] = 0
g["indentLine_setConceal"] = 0
-- GitCommit
----------
g["EditorConfig_exclude_patterns"] = { "fugitive://.*", "scp://.*" }
cmd([[ au FileType gitcommit let b:EditorConfig_disable = 1 ]])
----------

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
keymap.set("n", "U", ":redo<CR>", { silent = true, noremap = true })
-- Remap Visual and Insert mode to use Normal Modes Tab Rules
keymap.set("i", ">>", "<c-t>", {})
keymap.set("i", "<<", "<c-d>", {})
----------

-- File Mappings
----------
-- Set Write/Quit to shortcuts
keymap.set("n", "<leader>ww", ":w<CR>", { silent = false, noremap = true, desc = "Write" })
keymap.set("n", "<leader>w!", ":w!<CR>", { silent = false, noremap = true, desc = "Over-Write" })
keymap.set("n", "<leader>ws", ":so<CR>", { silent = false, noremap = true, desc = "Write and Source to Nvim" })
keymap.set("n", "<leader>wqq", ":wq<CR>", { silent = false, noremap = true, desc = "Close Buffer" })
keymap.set("n", "<leader>wqa", ":wqa<CR>", { silent = false, noremap = true, desc = "Write All & Quit Nvim" })
keymap.set("n", "<leader>wa", ":wa<CR>", { silent = false, noremap = true, desc = "Write All" })
keymap.set("n", "<leader>qaa", ":qa<CR>", { silent = false, noremap = true, desc = "Quit Nvim" })
keymap.set("n", "<leader>qa!", "<cmd>qa!<cr>", { silent = false, noremap = true, desc = "Quit Nvim Without Writing" })
keymap.set("n", "<leader>qq", ":q<CR>", { silent = false, noremap = true, desc = "Close Buffer" })
keymap.set("n", "<leader>q!", ":q!<CR>", { silent = false, noremap = true, desc = "Close Buffer Without Writing" })
-- System Copy Set to Mappings
keymap.set({ "n", "v" }, "<leader>y", '"+y', { silent = true, noremap = true, desc = "Copy to System Clipboard" })
keymap.set(
	{ "n", "v" },
	"<leader>yy",
	'"+yy',
	{ silent = true, noremap = true, desc = "Copy Line to System Clipboard" }
)
keymap.set("n", "<leader>yG", '"+yG', { silent = true, noremap = true, desc = "Copy Rest of file to system Clipboard" })
keymap.set(
	"n",
	"<leader>y%",
	'"+y%',
	{ silent = true, noremap = true, desc = "Copy Whole of file to system Clipboard" }
)
-- System Paste Set to Mappings
keymap.set({ "n", "v" }, "<leader>p", '"+p', { silent = true, noremap = true, desc = "Paste from System Clipboard" })
keymap.set({ "n", "v" }, "<leader>P", '"+P', { silent = true, noremap = true, desc = "Paste from System Clipboard" })
---------

-- Highlighting Search Mappings
---------
-- Trigger Highlight Searching Automatically
keymap.set("n", "<cr>", ":nohlsearch<CR>", { silent = true })
keymap.set("n", "n", ":set hlsearch<CR>n", { silent = true })
keymap.set("n", "N", ":set hlsearch<CR>N", { silent = true })
---------

-- Pane Control Mappings
----------
-- Tmux Pane Resizing Terminal Mode
keymap.set({ "t", "i", "c", "n" }, "<c-a><c-j>", "<c-\\><c-n>:res-5<CR>i", {})
keymap.set({ "t", "i", "c", "n" }, "<c-a><c-k>", "<c-\\><c-n>:res+5<CR>i", {})
keymap.set({ "t", "i", "c", "n" }, "<c-a><c-h>", "<c-\\><c-n>:vertical resize -5<CR>i", {})
keymap.set({ "t", "i", "c", "n" }, "<c-a><c-l>", "<c-\\><c-n>:vertical resize +5<CR>i", {})
----------

-- Tab Control mappings
----------
-- Navigation
keymap.set("", "<C-t>k", ":tabr<cr>", {})
keymap.set("", "<C-t>j", ":tabl<cr>", {})
keymap.set("", "<C-t>l", ":tabn<cr>", {})
keymap.set("", "<C-t>h", ":tabp<cr>", {})
-- Close Current Tab
keymap.set("", "<C-t>c", ":tabc<cr>", {})
-- Close all other Tabs
keymap.set("", "<C-t>o", ":tabo<cr>", {})
-- New Tab - note n is already used as a search text tool and cannot be mapped
keymap.set("", "<C-t><c-n>", ":tabnew<cr>", {})
----------

-- Auto-Comment Mappings
----------
local auto_comment = require("Comment").setup()
----------

----------------------------------
-- Editor Mapping Assistance -- Which Key
----------------------------------

-- Setup
---------------
local whichKey = require("which-key")
whichKey.setup()
---------------

-- Mappings
---------------
keymap.set(
	"n",
	"<leader>?",
	"<cmd>WhichKey<CR>",
	{ silent = true, noremap = false, desc = "Editor Mapping Assistance" }
)
---------------

-- General Menu Keys Register
---------------
whichKey.register({
	["]"] = { name = "Go To Next" },
	["["] = { name = "Go To Previous" },
})
----------

-----------------------------------------
--  Syntax Highlighting: Tree-Sitter Config
-----------------------------------------

-- Plugin Setup
----------
require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "rust", "toml", "markdown", "markdown_inline", "rst", "python", "bash", "vim", "regex" },
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
})
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
----------

--------------------------------
-- CmdLine Settings - Noice.nvim
--------------------------------

require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
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

-----------------------------
-- Status Line - LuaLine
-----------------------------

-- Helper Functions
----------
-- Get accurate time on panel
function Zonedtime(hours)
	-- Change time zone here (default seems to be +12 on home workstation)
	local zone_difference = 11
	local t = os.time() - (zone_difference * 3600)
	local d = t + hours * 3600
	return os.date("%H:%M %Y-%m-%d", d)
end

-- Functions to make an active lsp panel
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
}

local active_formatter = {
	function()
		local formatters = require("conform").list_formatters_for_buffer(0)
		if formatters ~= nil then
			return string.format(" %s", table.concat(formatters, ", "))
		else
			return ""
		end
	end,
}

local active_lint = {
	function()
		local linters = require("lint").linters_by_ft[vim.bo.filetype][1]
		if linters ~= nil then
			return string.format("󰯠 %s", linters)
		else
			return ""
		end
	end,
}

-- local noice_mode = {
-- 	require("noice").api.statusline.mode.get,
-- 	cond = require("noice").api.statusline.mode.has,
-- 	color = { fg = "#ff9e64" },
-- }

-- Config
----------
require("lualine").setup({
	options = {
		section_separators = { left = "|", right = "|" },
		component_separators = { left = "", right = "" },
		theme = "gruvbox-material",
	},
	sections = {
		lualine_a = { {
			"mode",
			fmt = function(res)
				return res:sub(1, 1)
			end,
		} },
		lualine_b = {
			"branch",
			{ "diff", symbols = { added = "[+] ", modified = "[~] ", removed = "[-] " } },
			"diagnostics",
		},
		lualine_c = {
			{ "filetype", colored = true, icon_only = true, icon = { align = "right" } },
			"filename",
			noice_mode,
		},
		lualine_x = { active_lsp, active_lint, active_formatter },
		lualine_y = { "progress", "location" },
		lualine_z = { "Zonedtime(11)" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
})
----------

-----------------------------
-- Start Page - alpha.nvim
-----------------------------

-- Config
----------
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
alpha.setup(dashboard.config)
----------

-----------------------------------------
-- Leader Remappings, Plugin Commands
-----------------------------------------

-- Note
---------
-- I'll use leader mappings for plugins and super extra goodies
-- however ones I use all the time will be mapped to `<c-` or a specific key
-- This follows the conventions <leader>{plugin key}{command key}
-- I've listed already use leader commands here
----------

-- Mappings
----------
-- Configured Here --
-- Terminal - TerminalToggle : <leader>t & <leader> q (while in terminal mode)
-- Other Terminal Apps: <leader>a
--     Docker - lazydocker: <leader>ad
-- Via Telescope
--    Filetree - telescope-file-browser : <c-n>
--    Project Management - telescope-project: <leader>m
--    Buffer Management - Telescope Nvim: <leader>f
-- Database - DadBod: : <leader>d
-- Code Execution & Testing - neotest: <leader>x (T is being used for the terminal)
-- Code Alignment - EasyAlign : <leader>e
-- Wiki Commands - Obsidian.nvim: <leader>k,
-- Previously Configured --
-- Write Commands: <leader>w
-- Quit Commands: <leader>q
-- System Yank Commands: <leader>y
-- System Paste Comnmands: <leader>p
-- Key Mapping Assist - whichkey: <leader>?
-- Configured in init.lsp --
-- Snippets - LuaSnip : <leader>s
-- Debugging - NvimDAP: <leader>b
-- Code Actions and Diagnostics - nvim-lsp, nvim-cmp (and dependents): <leader>c
-- Code Actions and Diagnostics - nvim-lsp, nvim-cmp (and dependents): <leader>g
----------

-- Key Map Assitance
----------
-- Disable some so I can recustomize them
local presets = require("which-key.plugins.presets")
presets.operators["<leader>c"] = nil

-- Register Custom Menus
whichKey.register({
	["<leader>"] = {
		y = { name = "System Copy" },
		p = { name = "System Paste" },
		m = { name = "Project Management @TODO" },
		w = { name = "File Write" },
		k = { name = "Wiki Opts" },
		q = { name = "Close and Quit" },
		t = { name = "Terminal" },
		a = { name = "Terminal Applications" },
		s = { name = "Snippets" },
		f = {
			name = "Telescope",
			d = { "Diff Options" },
			v = { "Git Options" },
		},
		d = { name = "Database" },
		b = { name = "Debugging" },
		c = { name = "LSP Opts" },
		x = { name = "Code Execute/Test" },
		r = { name = "Flashcards" },
	},
})
---------

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
	direction = "tab",
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
keymap.set(
	"n",
	"<leader>t",
	"<cmd>lua Standard_term_toggle()<CR>",
	{ noremap = true, silent = true, desc = "Open Terminal" }
)
-- Docker Toggle
keymap.set(
	"n",
	"<leader>ad",
	"<cmd>lua Docker_term_toggle()<CR>",
	{ noremap = true, silent = true, desc = "Open Docker Container Management" }
)
-- Gitui Toggle
keymap.set(
	"n",
	"<leader>ag",
	"<cmd>lua Gitui_term_toggle()<CR>",
	{ noremap = true, silent = true, desc = "Open Git Ui" }
)
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
			["l"] = fb_actions.change_cwd,
			["h"] = fb_actions.goto_parent_dir,
			["c"] = fb_actions.goto_cwd,
			["<C-h>"] = fb_actions.toggle_hidden,
			["a"] = fb_actions.create,
			["H"] = fb_actions.toggle_hidden,
		},
		-- Insert Mode
		["i"] = {
			["<C-n>"] = tele_actions.close,
			["<C-l>"] = fb_actions.change_cwd,
			["<C-h>"] = fb_actions.goto_parent_dir,
			["<c-j>"] = tele_actions.move_selection_next,
			["<c-k>"] = tele_actions.move_selection_previous,
			["<C-c>"] = fb_actions.goto_cwd,
			["<A-h>"] = fb_actions.toggle_hidden,
			["<c-a>"] = fb_actions.create,
		},
	},
}
----------

-- Mappings
----------
keymap.set(
	"n",
	"<C-n>",
	":Telescope file_browser theme=dropdown<CR>",
	{ silent = true, noremap = true, desc = "Toggle File Browser" }
) -- Remap the open and close to C-n
----------

-----------------------------
-- Project Management: <leader>m - telescope-project @TODO
-----------------------------

-- Functions
----------
local project_actions = require("telescope._extensions.project.actions")
----------

-- Config
----------
local project_configs = {}
----------

-----------------------------
-- Ui-Select Management: - Ui Improvements, not mapped to a keybinding
-----------------------------

-- Functions
----------
local ui_select_actions = require("telescope._extensions.project.actions")
----------

-- Config
----------
local ui_select_configs = {}
----------
---------------------------------
-- Buffer Management: <leader>f  - Telescope Core
---------------------------------

-- Mappings
----------
-- Buffers Mappings
keymap.set(
	"n",
	"<leader>ff",
	"<cmd>Telescope find_files theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Find Files" }
)
-- Find File
keymap.set(
	"n",
	"<leader>fg",
	"<cmd>Telescope live_grep theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Live Grep" }
)
-- Find Buffer
keymap.set(
	"n",
	"<leader>fb",
	"<cmd>Telescope buffers theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Show Buffers" }
)
keymap.set("n", "<C-b>s", "<cmd>Telescope buffers theme=dropdown<cr>", { silent = true, noremap = true })
-- Registers
keymap.set(
	"n",
	"<leader>fr",
	"<cmd>Telescope registers theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Registers" }
)
-- Help Mappings
keymap.set(
	"n",
	"<leader>fh",
	"<cmd>Telescope help_tags theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Help Tags" }
)
-- Man Pages
keymap.set(
	"n",
	"<leader>fm",
	"<cmd>Telescope man_pages theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Man Pages" }
)
-- Keymaps
keymap.set(
	"n",
	"<leader>fk",
	"<cmd>Telescope keymaps theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Keymaps" }
)
-- ColorScheme
keymap.set(
	"n",
	"<leader>fc",
	"<cmd>Telescope colorscheme theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Keymaps" }
)
-- Tree Sitter Mapping
keymap.set(
	"n",
	"<leader>fs",
	"<cmd>Telescope treesitter theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Treesitter Insights" }
)
-- Telescope Telescopes
keymap.set(
	"n",
	"<leader>ft",
	"<cmd>Telescope builtin theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Telescope" }
)
-- Imports
----------
keymap.set(
	"n",
	"<leader>fi",
	"<cmd>Telescope import theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Imports" }
)
-- Version Control - git
----------
-- Commits
keymap.set(
	"n",
	"<leader>fvc",
	"<cmd>Telescope git_commits theme=dropdown theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Git Commits" }
)
-- Status
keymap.set(
	"n",
	"<leader>fvs",
	"<cmd>Telescope git_status theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Git Status" }
)
-- Branches
keymap.set(
	"n",
	"<leader>fvb",
	"<cmd>Telescope git_branches theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Git Branches" }
)
-- Git Files
keymap.set(
	"n",
	"<leader>fvf",
	"<cmd>Telescope git_files theme=dropdown<cr>",
	{ silent = true, desc = "Telescope: Git Branches" }
)
----------

---------------------------------
-- Telescope Setup
---------------------------------

-- Setup
----------
require("telescope").setup({
	pickers = {
		buffers = {
			mappings = {
				-- Redo this action so you can take a parameter that allows for force = true and force = false for unsaved files
				i = {
					["<c-d>"] = tele_actions.delete_buffer,
					["<c-k>"] = tele_actions.move_selection_previous,
					["<c-j>"] = tele_actions.move_selection_next,
				},
			},
		},
	},
	extensions = {
		file_browser = file_browser_configs,
		project = project_configs,
        ui_select = ui_select_configs,
	},
})

-- Extension Setup (Must Go last)
require("telescope").load_extension("file_browser")
require("telescope").load_extension("project")
require("telescope").load_extension("import")
require("telescope").load_extension("ui-select")
----------

---------
-- End of Telescope Setup
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
keymap.set("n", "<leader>kb", "<cmd>ObsidianBacklinks<cr>", { silent = true, desc = "Get References To Current" })
keymap.set("n", "<leader>kt", "<cmd>ObsidianToday<cr>", { silent = true, desc = "Open (New) Daily Note" })
keymap.set(
	"n",
	"<leader>ky",
	"<cmd>ObsidianYesterday<cr>",
	{ silent = true, desc = "Create New Daily Note For Yesterday" }
)
keymap.set("n", "<leader>ko", "<cmd>ObsidianOpen<cr>", { silent = true, desc = "Open in Obisidian App" })
keymap.set("n", "<leader>kcn", ":ObsidianNew ", { silent = false, desc = "Create New Note" })
keymap.set("v", "<leader>kcl", ":ObsidianLinkNew ", { silent = false, desc = "Created New Linked Note" })
keymap.set("n", "<leader>ks", "<cmd>ObsidianSearch<cr>", { silent = true, desc = "Search Vault Notes" })
keymap.set("n", "<leader>kq", "<cmd>ObsidianQuickSwitch<cr>", { silent = true, desc = "Note Quick Switch" })
keymap.set("n", "<leader>kll", "<cmd>ObsidianFollowLink<cr>", { silent = true, desc = "Go To Link Under Cursor" })
keymap.set("v", "<leader>kla", "<cmd>ObsidianLink<cr>", { silent = true, desc = "Link Note To Selection" })
keymap.set("n", "<leader>klt", "<cmd>ObsidianTemplate<cr>", { silent = true, desc = "Insert Template Into Link" })
-- Mapping Assist
whichKey.register({
	["<leader>k"] = {
		c = { name = "Create New" },
		l = { name = "Links Opts" },
	},
})
-----------

---------------------------------
-- Easy Align
---------------------------------

-- Mappings
----------
-- Start interactive EasyAlign in visual mode (e.g. vipga)
keymap.set("x", "<leader>e", "<Plug>(EasyAlign)<CR>", { desc = "Easy Align" })

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
keymap.set("n", "<leader>e", "<Plug>(EasyAlign)<CR>", { desc = "Easy Align" })
----------

---------------------------------"
-- Database Commands - DadBod
---------------------------------"

-- Options
---------
g["db_ui_save_location"] = "~/.config/db_ui"
g["dd_ui_use_nerd_fonts"] = 1
----------

-- Mappings
---------
keymap.set("n", "<leader>du", ":DBUIToggle<CR>", { silent = true, desc = "Toggle DB UI" })
keymap.set("n", "<leader>df", ":DBUIFindBuffer<CR>", { silent = true, desc = "Find DB Buffer" })
keymap.set("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { silent = true, desc = "Rename DB Buffer" })
keymap.set("n", "<leader>dl", ":DBUILastQueryInfo<CR>", { silent = true, desc = "Run Last Query" })
---------

---------------------------------"
-- Code Execution and Testing - neotest
---------------------------------"

-- Create AutoCommandGroup
api.nvim_create_augroup("RunCodeCommands", { clear = true })
----------

-- Create Run Command on BufAttach
----------
api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufNew" }, {
	callback = function()
		vim.g.RunCommand = vim.bo.filetype .. " " .. vim.api.nvim_buf_get_name(0)
	end,
})
----------

-- Setup Terminal Runner
----------
-- Setup Toggle function
function Runner_term_toggle()
	local runner_client = Terminal:new({
		cmd = vim.g.RunCommand,
		dir = fn.getcwd(),
		hidden = true,
		direction = "float",
		float_opts = {
			border = "double",
		},
		close_on_exit = false,
	})
	runner_client:toggle()
end

-- Keymap to Run
keymap.set(
	"n",
	"<leader>xx",
	"<cmd>lua Runner_term_toggle()<CR>",
	{ noremap = true, silent = true, desc = "Run Current Buffer" }
)
----------

---------------------------------"
-- LSP Config
---------------------------------"

-- Notes
----------
-- All Lsp Settings are configured in nvim/lua/lsp.lua
----------

-- Commands
----------
api.nvim_create_user_command("Editlsp", "e ~/.config/nvim/lua/lsp.lua", {})
----------

-- Load File
----------
require("lsp")
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
--------------------------------
