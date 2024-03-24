-------------------------
-- ###################  --
-- # Main Vim Config #  --
-- ###################  --
--------------------------

--------------------------------
-- TO DO
--------------------------------
-- None
--
--------------------------------

-------------------------------
-- Priority Settings
-------------------------------
-- Set the config path
vim.g["config_path"] = "~/.config/nvim"
-- Set the mapleader
vim.g["mapleader"] = "\\"

--------------------------------
-- Luaisms for Vim Stuff
--------------------------------

-- Apis, Functions, Commands
----------
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local system = vim.fn.system
local fs = vim.fs -- vim filesystem
local ui = vim.ui -- vim ui options
local keymap = vim.keymap
local ft = vim.filetype
local hl = vim.api.nvim_set_hl
local loop = vim.loop
local diagnostics = vim.diagnostic
-- For Options
local opt = vim.opt -- vim options
-- For Variables
local gv = vim.g -- global variables
----------

-- Functions
----------

-- Keyopts
----------
local function keyopts(opts)
	local standardOpts = { silent = true, noremap = true }
	for k, v in pairs(standardOpts) do
		opts[k] = v
	end
	return opts
end

local function loudkeyopts(opts)
	local standardOpts = { silent = false, noremap = true }
	for k, v in pairs(standardOpts) do
		opts[k] = v
	end
	return opts
end
-- Abstraction for the vast majority of my keymappings
local function norm_keyset(key, command, wkdesc)
	keymap.set("n", key, "<cmd>" .. command .. "<CR>", { silent = true, noremap = true, desc = wkdesc })
end
----------

-- Map(function, table)
----------
function Map(func, tbl)
	local newtbl = {}
	for i, v in pairs(tbl) do
		newtbl[i] = func(v)
	end
	return newtbl
end
----------

-- Filter(function, table)
----------
function Filter(func, tbl)
	local newtbl = {}
	for i, v in pairs(tbl) do
		if func(v) then
			newtbl[i] = v
		end
	end
	return newtbl
end
----------

-- Concat two Tables
----------
local function tableConcat(t1, t2)
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
	return t1
end
----------

-- Python Path
----------
local function get_python_path()
	-- Use Activated Environment
	if vim.env.VIRTUAL_ENV then
		return vim.env.VIRTUAL_ENV .. "/bin/" .. "python"
	end
	-- Fallback to System Python
	return fn.exepath("python3") or fn.exepath("python") or "python"
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
	{ "nvim-lua/plenary.nvim", event = "VeryLazy" },
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-context",
		},
	},
	{
		"vhyrro/luarocks.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		priority = 1000,
		config = true,
	},
	{
		"rest-nvim/rest.nvim",
		ft = "http",
		dependencies = { "luarocks.nvim" },
		config = function()
			require("rest-nvim").setup()
		end,
	},
	{},
	"folke/neodev.nvim",
	-- Autocompletion & Snips
	----------
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Sources
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"ray-x/cmp-treesitter",
			"SergioRibera/cmp-dotenv",
			"dmitmel/cmp-cmdline-history",
			"yochem/cmp-htmx",
			"saadparwaiz1/cmp_luasnip",
			"f3fora/cmp-spell",
			"jmbuhr/otter.nvim",
			-- Dependencies
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
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
	{ "mfussenegger/nvim-lint", event = "VeryLazy" },
	-- Formatting
	----------
	{ "stevearc/conform.nvim", event = "VeryLazy" },
	-- Inejected Languages
	----------
	"jmbuhr/otter.nvim",
	-- Debug Adapter Protocol
	----------
	{
		"mfussenegger/nvim-dap",
		dependencies = { "mfussenegger/nvim-dap-python", "theHamsta/nvim-dap-virtual-text" },
	},
	-- Code Running
	----------
	{
		"mesa123123/compiler.nvim",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		dependencies = { "stevearc/overseer.nvim" },
		opts = {},
	},
	{
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
	----------
	-- Assistance Plugins
	----------
	"folke/which-key.nvim",
	{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, event = "VeryLazy" },
	{ "numToStr/Comment.nvim", lazy = false },
	-- Testing Plugins
	--------
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio", -- Currently broken on my config....
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
			-- "rouge8/neotest-rust",
			"andythigpen/nvim-coverage",
		},
		event = "VeryLazy",
	},
	-- Database Workbench,
	-----------
	{ "tpope/vim-dadbod", event = "VeryLazy", dependencies = "kristijanhusak/vim-dadbod-ui" },
	-- Versions Control
	----------
	{ "tpope/vim-fugitive", event = "VeryLazy" },
	-- Status/Window Lines
	------------
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
	},
	{
		"utilyre/barbecue.nvim",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
	},
	------------
	-- Colors and Themes
	------------
	-- DevIcons
	"nvim-tree/nvim-web-devicons",
	-- Theme
	"ellisonleao/gruvbox.nvim",
	-- Brackets Rainbowing
	"luochen1990/rainbow",
	-- Highlights Hex Colors as their color
	"norcalli/nvim-colorizer.lua",
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
	-- LSP Icons
	{ "onsails/lspkind.nvim", event = "VeryLazy" },
	-- Dashboard
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- Folding
	----------
	"anuvyklack/pretty-fold.nvim",
	----------
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
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	----------
	-- Nvim Telescope
	---------
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"BurntSushi/ripgrep",
			"sharkdp/fd",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"piersolenski/telescope-import.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		event = "VeryLazy",
	},
	----------
	-- Writing Functionality
	----------
	-- Wiki - Obsidian nvim
	{ "epwalsh/obsidian.nvim", event = "VeryLazy" },
	-- Latex - VimTex
	"lervag/vimtex",
	----------
	-- Alignment
	{ "junegunn/vim-easy-align", event = "VeryLazy" },
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
	extension = { hcl = "ini", draft = "markdown", env = "config", jinja = "jinja", vy = "python" },
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
set_shift_and_tab(2, { "*.cpp", "*.ts", "*.md", ".draft" })
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
diagnostics.config({ virtual_text = true })
------------

-- Section: Commands
----------
-- #FIX: This doesn't seem to do anything, or output to console
api.nvim_create_user_command("DepInstall", function()
	if vim.bo.filetype == "python" then
		print("Installing via pip")
		local output = vim.fn.system("pip install -r " .. vim.fn.getcwd() .. "/requirements.txt")
		print(output)
	end
end, { nargs = 0 })
----------

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
require("pretty-fold").setup()
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

-- Set TermGuiColors true
----------
opt.termguicolors = true
----------

-- Load Color Scheme
----------
require("gruvbox").setup({ contrast = "hard", transparent_mode = true })
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
			color = "#51a0cf",
			cterm_color = "196",
			name = "requirements",
		},
		["dev-requirements.txt"] = {
			icon = "",
			color = "#51a0cf",
			cterm_color = "196",
			name = "requirements",
		},
	},
})
-- Setup Custom Icons
devIcons.set_icon({
	htmldjango = {
		icon = "",
		color = "#e44d26",
		cterm_color = "196",
		name = "Htmldjango",
	},
	jinja = {
		icon = "",
		color = "#e44d26",
		cterm_color = "196",
		name = "Jinja",
	},
	rst = {
		icon = "",
		color = "#55cc55",
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
hl(0, "LspDiagnosticsUnderlineError", { bg = "#EB4917", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineWarning", { bg = "#EBA217", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineInformation", { bg = "#17D6EB", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineHint", { bg = "#17EB7A", underline = true, blend = 50 })
----------

-- Highlight Colors as their Color
----------
require("colorizer").setup()
----------

-----------------------------
-- Start Page - alpha.nvim
-----------------------------

-- Config
----------
local alpha = require("alpha")
local dashboard = require("alpha.themes.theta")
local dashboard_opts = require("alpha.themes.dashboard")
dashboard.header.val = {
	"<-.(`-')    _       (`-')  _                    (`-')   (`-')  _          (`-')       (`-')  _      (`-')  _             ",
	" __( OO)   (_)      (OO ).-/           .->   <-.(OO )   (OO ).-/          ( OO).->    ( OO).-/      (OO ).-/       .->   ",
	"'-'. ,--.  ,-(`-')  / ,---.       (`-')----. ,------,)  / ,---.           /    '._   (,------.      / ,---.   (`-')----. ",
	"|  .'   /  | ( OO)  | \\ /`.\\      ( OO).-.  '|   /`. '  | \\ /`.\\          |'--...__)  |  .---'      | \\ /`.\\  ( OO).-.  '",
	"|      /)  |  |  )  '-'|_.' |     ( _) | |  ||  |_.' |  '-'|_.' |         `--.  .--' (|  '--.       '-'|_.' | ( _) | |  |",
	"|  .   '  (|  |_/  (|  .-.  |      \\|  |)|  ||  .   .' (|  .-.  |            |  |     |  .--'      (|  .-.  |  \\|  |)|  |",
	"|  |\\   \\  |  |'->  |  | |  |       '  '-'  '|  |\\  \\   |  | |  | ,-.        |  |     |  `---.      |  | |  |   '  '-'  '",
	"`--' '--'  `--'     `--' `--'        `-----' `--' '--'  `--' `--' './        `--'     `------'      `--' `--'    `-----' ",
	"                                                                                                ",
	"-------------------------------------------------------------------------------------------------------------------",
	"                                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                  ",
}
dashboard.buttons.val = {
	{ type = "text", val = "Options", opts = { hl = "SpecialComment", position = "center" } },
	dashboard_opts.button("n", "  Open File-system", ":Telescope file_browser theme=dropdown<CR>"),
	dashboard_opts.button("v", "  EditVim", "<cmd>e ~/.config/nvim/init.lua<CR>"),
	dashboard_opts.button("l", "  Editlsp", "<cmd>e ~/.config/nvim/lua/lsp.lua<CR>"),
}
local section_mru = {
	type = "group",
	val = {
		{
			type = "text",
			val = "Recent files",
			opts = {
				hl = "SpecialComment",
				shrink_margin = false,
				position = "center",
			},
		},
		{
			type = "group",
			val = function()
				return { dashboard.mru(0, fn.getcwd(), 6) }
			end,
			opts = { shrink_margin = false },
		},
	},
}
dashboard.config.layout = {
	{ type = "padding", val = 2 },
	dashboard.header,
	{ type = "padding", val = 2 },
	dashboard.buttons,
	{ type = "padding", val = 1 },
	section_mru,
}

alpha.setup(dashboard.config)
----------

-------------------------------
-- Neovim Extender Plug-ins
-------------------------------

--Neodev
local neodev = require("neodev")
-- neodev.setup({
-- 	library = { plugins = { "neotest" }, types = true },
-- })
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
keymap.set("n", "<leader>ww", ":w<CR>", loudkeyopts({ desc = "Write" }))
keymap.set("n", "<leader>w!", ":w!<CR>", loudkeyopts({ desc = "Over-Write" }))
keymap.set("n", "<leader>ws", ":so<CR>", loudkeyopts({ desc = "Write and Source to Nvim" }))
keymap.set("n", "<leader>wqq", ":wq<CR>", loudkeyopts({ desc = "Close Buffer" }))
keymap.set("n", "<leader>wqb", ":w<CR>:bd<CR>", loudkeyopts({ desc = "Write and Close Buffer w/o Pane" }))
keymap.set("n", "<leader>wqa", ":wqa<CR>", loudkeyopts({ desc = "Write All & Quit Nvim" }))
keymap.set("n", "<leader>wa", ":wa<CR>", loudkeyopts({ desc = "Write All" }))
keymap.set("n", "<leader>qaa", ":qa<CR>", loudkeyopts({ desc = "Quit Nvim" }))
keymap.set("n", "<leader>qa!", "<cmd>qa!<cr>", loudkeyopts({ desc = "Quit Nvim Without Writing" }))
keymap.set("n", "<leader>qq", ":q<CR>", loudkeyopts({ desc = "Close Buffer and Pane" }))
keymap.set("n", "<leader>qbb", ":bd<CR>", loudkeyopts({ desc = "Close Buffer w/o Pane" }))
keymap.set("n", "<leader>qb!", ":bd<CR>", loudkeyopts({ desc = "Close Buffer w/o Pane" }))
keymap.set("n", "<leader>q!", ":q!<CR>", loudkeyopts({ desc = "Close Buffer Without Writing" }))
-- System Copy Set to Mappings
keymap.set({ "n", "v" }, "<leader>y", '"+y', keyopts({ desc = "System Copy" }))
keymap.set({ "n", "v" }, "<leader>yy", '"+yy', keyopts({ desc = "System Copy: Line" }))
keymap.set("n", "<leader>yG", '"+yG', keyopts({ desc = "System Copy: Rest of File" }))
keymap.set("n", "<leader>y%", '"+y%', keyopts({ desc = "System Copy: Whole of File" }))
-- System Paste Set to Mappings
keymap.set({ "n", "v" }, "<leader>p", '"+p', keyopts({ desc = "System Paste" }))
---------

-- Highlighting Search Mappings
---------
-- Trigger Highlight Searching Automatically
keymap.set("n", "<cr>", ":nohlsearch<CR>", keyopts({}))
keymap.set("n", "n", ":set hlsearch<CR>n", keyopts({}))
keymap.set("n", "N", ":set hlsearch<CR>N", keyopts({}))
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
keymap.set("", "<C-t>j", ":table<cr>", {})
keymap.set("", "<C-t>l", ":tabn<cr>", {})
keymap.set("", "<C-t>h", ":tabp<cr>", {})
-- Close Current Tab
keymap.set("", "<C-t>c", ":tabc<cr>", {})
-- Close all other Tabs
keymap.set("", "<C-t>o", ":tabo<cr>", {})
-- New Tab - note n is already used as a search text tool and cannot be mapped
keymap.set("", "<C-t><c-n>", ":tabnew<cr>", {})
----------

-- Buffer Control Mappings
----------
keymap.set("n", "<leader>fl", "<cmd>bnext<CR>", { silent = true, desc = "Next Buff" })
keymap.set("n", "<leader>fh", "<cmd>bprev<CR>", { silent = true, desc = "Prev Buff" })
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
	["<C-b>"] = { name = "Buffer Changes" },
})
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
norm_keyset("<leader>hc", "TSContextEnable", "Context Highlight On")
norm_keyset("<leader>hs", "TSContextDisable", "Context Highlight Off")
norm_keyset("<leader>ht", "TSContextToggle", "Context Highlight Toggle")
norm_keyset("[c", 'lua require(treesitter-context").go_to_context(vim.v.count1)', "Context Highlight Toggle")
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
hl(0, "NotifyBackground", { bg = "#414141" })
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
	color = { fg = "f84935" },
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
	color = { fg = "#8ec07c" },
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
	color = { fg = "#eab133" },
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
	color = { fg = "#f84935" },
	fmt = trunc(120, 4, 90, true),
}
------------------

-- Show if a macro is recording
------------------
local noice_recording = {
	function()
		local noice_stats = require("noice").api.statusline.mode.get()
		if string.find(noice_stats, "recording") ~= nil then
			return string.format("󰑋 %s", string.sub(noice_stats, string.len(noice_stats)))
		else
			return ""
		end
	end,
	cond = require("noice").api.statusline.mode.has,
	color = { fg = "#282828" },
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
				symbols = { error = "E-", warn = "W-", info = "I-", hint = "H-" },
				fmt = trunc(120, 10000, 120, true),
			},
		},
		lualine_c = {
			{ "filetype", colored = true, icon_only = true, icon = { align = "right" }, fmt = trunc(120, 4, 90, true) },
			{ "filename" },
			debug_status,
			{ "overseer", colored = true },
		},
		lualine_x = { active_lsp, active_lint, active_formatter },
		lualine_y = { { "progress", fmt = trunc(120, 10000, 120, true) }, { "location" } },
		lualine_z = { "Zonedtime(11)" },
	},
})
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
--     GitUi - Gitui: <leader>ag
-- Database - DadBod: : <leader>d
-- Code Alignment - EasyAlign : <leader>e
-- Wiki Commands - Obsidian.nvim: <leader>k,
-- Code Execution & Http Calls & Testing - compiler, neotest: <leader>x (T is being used for the terminal)
-- Via Telescope --
--    Filetree - telescope-file-browser : <c-n>
--    Buffer Management - Telescope Nvim: <leader>f
-- Previously Configured --
--    Key Mapping Assist - whichkey: <leader>?
--    Highlighting Options - Treesitter: <leader>h
--    Todo Highlights -- todocomments.nvim: <leader>m
--    System Paste Comnmands: <leader>p
--    Quit Commands: <leader>q
--    Version Control Commands -- fugitive: <leader>v
--    Write Commands: <leader>w
--    System Yank Commands: <leader>y
-- Configured in init.lsp --
--    Debugging - NvimDAP: <leader>b
--    Code Actions and Diagnostics - nvim-lsp, nvim-cmp (and dependents): <leader>c
--    Snippets - LuaSnip : <leader>s
-- ---------- --
----------

-- Key Map Assistance
----------
-- Disable some so I can recustomize them
local presets = require("which-key.plugins.presets")
presets.operators["<leader>c"] = nil

-- Register Custom Menus
whichKey.register({
	["<leader>"] = {
		a = { name = "Terminal Applications" },
		b = { name = "Debugging" },
		c = { name = "LSP Opts" },
		d = { name = "Database" },
		f = { name = "Telescope" },
		h = { name = "Highlighting Options" },
		k = { name = "Wiki Opts" },
		l = { name = "VimTex" },
		m = { name = "Todos" },
		p = { name = "System Paste" },
		q = { name = "Close and Quit" },
		r = { name = "Flashcards" },
		s = { name = "Snippets" },
		v = { name = "Version Control", f = { "Telescope Options" } },
		w = { name = "File Write" },
		x = { name = "Code Execute/Test" },
		y = { name = "System Copy" },
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
keymap.set("n", "<C-n>", ":Telescope file_browser theme=dropdown<CR>", keyopts({ desc = "Toggle File Browser" })) -- Remap the open and close to C-n
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
end, { desc = "Next todo comment" })

keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

keymap.set("n", "<leader>m", "<cmd>TodoTelescope<CR>", keyopts({ desc = "List Todos" }))
----------

---------------------------------
-- Buffer Management: <leader>f  - Telescope Core
---------------------------------

-- Mappings
----------
-- Find Buffer
norm_keyset("<leader>fb", "Telescope buffers theme=dropdown", "Show Buffers")
norm_keyset("<C-b>s", "Telescope buffers theme=dropdown", "Show Buffers")
-- ColorScheme
norm_keyset("<leader>fc", "Telescope colorscheme theme=dropdown", "Themes")
-- Diagnostics (Also thorugh \cp
norm_keyset("<leader>fd", "Telescope diagnostics theme=dropdown", "Diagnostics")
-- Buffers Mappings
norm_keyset("<leader>ff", "Telescope find_files theme=dropdown", "Find Files")
-- Find File
norm_keyset("<leader>fg", "Telescope live_grep theme=dropdown", "Live Grep")
-- Help Mappings
norm_keyset("<leader>fH", "Telescope help_tags theme=dropdown", "Help Tags")
-- Imports
norm_keyset("<leader>fi", "Telescope import theme=dropdown", "Imports")
-- Jumplist
norm_keyset("<leader>fj", "Telescope jumplist theme=dropdown<CR>", "Jumplist")
-- Keymaps
norm_keyset("<leader>fk", "Telescope keymaps theme=dropdown", "Keymaps")
-- Man Pages
norm_keyset("<leader>fm", "Telescope man_pages theme=dropdown", "Man Pages")
-- Notifications
norm_keyset("<leader>fn", "Telescope notify", "Notifications")
-- Vim Options
norm_keyset("<leader>fo", "Telescope vim_options theme=dropdown<CR>", "Vim Options")
-- Registers
norm_keyset("<leader>fr", "Telescope registers theme=dropdown", "Registers")
-- Tree Sitter Mapping
norm_keyset("<leader>fs", "Telescope treesitter theme=dropdown", "Treesitter Insights")
-- Telescope Telescopes
norm_keyset("<leader>ft", "Telescope builtin theme=dropdown", "Telescope Commands")

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
require("telescope").load_extension("file_browser")
require("telescope").load_extension("import")
require("telescope").load_extension("ui-select")
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
gv["db_ui_save_location"] = "~/.config/db_ui"
gv["dd_ui_use_nerd_fonts"] = 1
----------

-- Mappings
---------
keymap.set("n", "<leader>du", ":DBUIToggle<CR>", { silent = true, desc = "Toggle DB UI" })
keymap.set("n", "<leader>df", ":DBUIFindBuffer<CR>", { silent = true, desc = "Find DB Buffer" })
keymap.set("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { silent = true, desc = "Rename DB Buffer" })
keymap.set("n", "<leader>dl", ":DBUILastQueryInfo<CR>", { silent = true, desc = "Run Last Query" })
---------

---------------------------------"
-- Code Execution - compiler.nvim, overseer, vimtext
---------------------------------"

-- Mappings
----------
-- WhichKey -- Includes for testing and http calls too
whichKey.register({
	["<leader>x"] = {
		["t"] = { name = "Testing" },
		["h"] = { name = "Http Calls" },
		["c"] = { name = "Coverage" },
	},
})
-- Mappings
api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		if vim.bo.filetype == "tex" then
			vim.keymap.set(
				"n",
				"<leader>xx",
				"<cmd>VimtexCompile<CR>",
				{ silent = true, noremap = false, desc = "Compile Doc" }
			)
		else
			vim.keymap.set(
				"n",
				"<leader>xx",
				"<cmd>CompilerOpen<CR>",
				{ silent = true, noremap = false, desc = "Run Code" }
			)
		end
	end,
})
norm_keyset("<leader>xq", "CompilerStop", "Stop Code Runner")
norm_keyset("<leader>xi", "CompilerToggleResults", "Show Code Run")
keymap.set("n", "<leader>xr", "<cmd>CompilerStop<cr>" .. "<cmd>CompilerRedo<cr>", keyopts({ desc = "Re-Run Code" }))
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

---------------------------------"
-- Http Execution - rest.nvim
---------------------------------"

norm_keyset("<leader>xhx", "RestNvim", "Run Http Under Cursor")
norm_keyset("<leader>xhp", "RestNvimPreview", "Preview Curl Command From Http Under Cursor")
norm_keyset("<leader>xhx", "RestNvim", "Re-Run Last Http Command")

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
norm_keyset("<leader>xtx", "lua require('neotest').run.run(vim.fn.expand('%'))", "Test Current Buffer")
norm_keyset("<leader>xto", "lua require('neotest').output.open({ enter = true, auto_close = true })", "Test Output")
norm_keyset("<leader>xts", "lua require('neotest').summary.toggle()", "Test Output (All Tests)")
norm_keyset("<leader>xtq", "lua require('neotest').run.stop()", "Quit Test Run")
norm_keyset("<leader>xtw", "lua require('neotest').watch.toggle(vim.fn.expand('%'))", "Toggle Test Refreshing")
norm_keyset("<leader>xtc", "lua require('neotest').run.run()", "Run Nearest Test")
norm_keyset("<leader>xtr", "lua require('neotest').run.run_last()", "Repeat Last Test Run")
norm_keyset(
	"<leader>xtb",
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
		covered = { fg = "#c3e88d" }, -- supports style, fg, bg, sp (see :h highlight-gui)
		uncovered = { fg = "#f07178" },
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
keymap.set("n", "<leader>xcr", "<cmd>Coverage<CR>", { noremap = true, silent = true, desc = "Run Coverage Report" })
keymap.set(
	"n",
	"<leader>xcs",
	"<cmd>CoverageSummary<CR>",
	{ noremap = true, silent = true, desc = "Show Coverage Report" }
)
keymap.set(
	"n",
	"<leader>xct",
	"<cmd>CoverageToggle<CR>",
	{ noremap = true, silent = true, desc = "Toggle Coverage Signs" }
)
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
