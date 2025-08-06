local M = {}

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
-- Module Table
local M = {}
local keymap = vim.keymap
----------

-- Require
----------
local utils = require("core.utils")
local keyopts = utils.keyopts
local makeDescMap = utils.desc_keymap
----------

-- Functions
----------
-- Saves having to type <leader> over and over again, also creates the assist descriptions as it goes
M.l = function(key, desc)
	local full_key = "<leader>" .. key
	return { key = full_key, desc = desc }
end
-- Creates a description for menu keys (keys that have sub keys)
M.makeDesc = function(km)
	keymap.set("n", "" .. km.key .. "", "<CMD>" .. km.key .. "<CR>", { desc = "Opts: " .. km.desc })
end

--------------------------------
-- Leader Key Vars
--------------------------------

M.lk = {
	-- System
	----------
	paste = M.l("p", "System Paste"),
	quit = M.l("q", "Close & Quit Commands"),
	quit_all = M.l("qa", "Quit All Commands"),
	quit_buffer = M.l("qb", "Quit Buffer Commands"),
	write = M.l("w", "File Write Commands"),
	write_quit = M.l("wq", "Write & Quit Commands"),
	yank = M.l("y", "System Copy"),
	sysRun = M.l("!", "Run System Command"),
	luaRun = M.l(":", "Run Lua Command"),
	-- Help
	assist = M.l("?", "Mapping Assist"),
	vimHelp = M.l(";", "Vim Help"),
	-- File Mgmt
	file = M.l("f", "File & Buffer Options"),
	window = M.l("t", "Window Options"),
	window_tab = M.l("tt", "Tab Options"),
	resize = M.l("r", "Pane Resize"),
	-- Terminal
	terminal = M.l("a", "Terminal Applications"),
	-- Run Code
	exec = M.l("x", "Code Execution"),
	exec_http = M.l("xh", "Http Calls"),
	exec_test = M.l("xt", "Testing"),
	exec_test_coverage = M.l("xtc", "Coverage"),
	-- Language Server
	----------
	-- Debugging
	debug = M.l("b", "Debug Opts"),
	debug_session = M.l("bs", "Session"),
	debug_fileView = M.l("bf", "Debug Views"),
	debug_languageOpts = M.l("bw", "Language Options"),
	debug_python = M.l("bP", "Python Options"),
	codeAction = M.l("c", "Code & Diagnostic Actions"),
	codeAction_symbols = M.l("cs", "Language Server Symbol Options"),
	codeAction_injectedLanguage = M.l("cL", "Injected Language Options"),
	codeAction_format = M.l("cf", "LSP: Format Code"),
	codeAction_lint = M.l("cl", "LSP: Lint Code"),
	codeAction_alignment = M.l("ce", "Code Alignment"),
	snippet = M.l("s", "Snippets"),
	------------
	-- Wiki
	----------
	wiki = M.l("k", "Wiki Options"),
	wiki_createPage = M.l("kc", "Create Options"),
	wiki_linkOpts = M.l("kl", "Link Options"),
	----------
	-- Misc
	----------
	-- Database
	database = M.l("d", "Database"),
	-- Notebook Functionality
	notebook = M.l("n", "Notebooks"),
	notebook_kernel = M.l("nk", "Notebook Kernel Opts"),
	notebook_insert = M.l("ni", "Notebook Insert Opts"),
	notebook_run = M.l("nx", "Notebook Insert Opts"),
	-- Highlighting Options - Treesitter: <leader>h
	hl = M.l("h", "Highlighting"),
	-- Version Control Commands -- fugitive: <leader>v
	vcs = M.l("v", "Version Control"),
	vcs_file = M.l("vf", "VCS: File Options"),
	-- Todo Highlights -- todocomments.nvim: <leader>m
	todo = M.l("m", "Todos"),
	-- Self Testing,
	selfTest = M.l("e", "Self-Testing ([E]xaminations)"),
	-- Document Creation And Templating,
	docCreation = M.l("l", "Document Formatting & Creation"),
	-- Zen Mode
	zen = M.l("z", "Zen Mode Toggle"),
	----------
}

--------------------------------
-- Key Mappings Table Normal
--------------------------------
M.setup = function()
	local lk = M.lk
	for k, v in pairs(lk) do
		M.makeDesc(v)
	end
	keymap.set("n", "[", "[", keyopts({ desc = "Go To Previous" }))
	keymap.set("n", "]", "]", keyopts({ desc = "Go To Next" }))
	keymap.set("n", "U", "redo", keyopts({ desc = "Redo" }))
	keymap.set({"n", "i"}, "<c-.>", "<c-t>", keyopts({ desc = "Tab forwards" }))
	keymap.set({"n", "i"}, "<c-,>", "<c-d>", keyopts({ desc = "Tab Backwards" }))
	keymap.set({"n", "v"}, "K", "H", keyopts({ desc = "Top of Page" }))
	keymap.set({"n", "v"}, "J", "L", keyopts({ desc = "Bottom of Page" }))
	keymap.set({"n", "v"}, "H", "0", keyopts({ desc = "Start of Line" }))
	keymap.set({"n", "v"}, "L", "$", keyopts({ desc = "End of Line" }))
	keymap.set("n", "0", "K", keyopts())
	keymap.set("n", "$", "J", keyopts())
	keymap.set("n", "dL", "d$", keyopts())
	keymap.set("n", "dH", "d0", keyopts())
	keymap.set("n", "yH", "y0", keyopts())
	keymap.set("n", "yL", "y$", keyopts())
	keymap.set({"n", "v"}, "<C-e>", "5<c-e>", keyopts())
	keymap.set({"n", "v"}, "<C-y>", "5<c-y>", keyopts())
	keymap.set("n", "<cr>", ":nohlsearch<CR>", keyopts())
	keymap.set("n", "n", ":set hlsearch<CR>n", keyopts())
	keymap.set("n", "N", ":set hlsearch<CR>N", keyopts())
	keymap.set({"n", "v"}, lk.paste.key, '"+p', keyopts({ desc = lk.paste.desc }))
	makeDescMap({"n", "v", "i"}, lk.resize, "j", ":res-5<CR>", "Move Partition Down")
	makeDescMap({"n", "v", "i"}, lk.resize, "k", ":res+5<CR>", "Move Partition Up")
	makeDescMap({"n", "v", "i"}, lk.resize, "h", ":vertical resize -5<CR>", "Move Partition Left")
	makeDescMap({"n", "v", "i"}, lk.resize, "l", ":vertical resize +5<CR>", "Move Partition Right")
	makeDescMap({"n", "v"}, lk.yank, "v", '"+y', "System Copy")
	makeDescMap({"n", "v"}, lk.yank, "y", '"+yy', "System Copy: Line")
	makeDescMap({"n", "v"}, lk.yank, "G", '"+yG', "System Copy: Rest of File")
	makeDescMap({"n", "v"}, lk.yank, "%", '"+y%', "System Copy: Whole of File")
	makeDescMap("n", lk.file, "l", ":bnext<CR>", "NextBuff")
	makeDescMap("n", lk.file, "h", ":bprev<CR>", "PrevBuff")
	makeDescMap("n", lk.write, "w", ":w<CR>", "Write")
	makeDescMap("n", lk.write, "!", ":w!<CR>", "Over-write")
	makeDescMap("n", lk.write, "s", ":so<CR>", "Write and Source to Nvim")
	makeDescMap("n", lk.write, "a", ":wa<CR>", "Write All")
	makeDescMap("n", lk.write_quit, ":q<CR>", "wq", "Close Buffer")
	makeDescMap("n", lk.write_quit, "b", ":w<CR>:bd<CR>", "Write and Close Buffer w/o Pane")
	makeDescMap("n", lk.write_quit, "a", ":wqa<CR>", "Write All & Quit Nvim")
	makeDescMap("n", lk.quit, "q", ":q<CR>", "Close Buffer and Pane")
	makeDescMap("n", lk.quit, "!", ":q!<CR>", "Close Buffer Without Writing")
	makeDescMap("n", lk.quit_buffer, "b", ":bd<CR>", "Close Buffer w/o Pane")
	makeDescMap("n", lk.quit_buffer, "!", ":bd<CR>", "Close Buffer w/o Pane")
	makeDescMap("n", lk.quit_all, "a", ":qa<CR>", "Quit Nvim")
	makeDescMap("n", lk.quit_all, "!", ":qa!<CR>", "Quit Nvim Without Writing")
	makeDescMap("n", lk.window, "v", ":vsplit<CR>", "Split Vertical")
	makeDescMap("n", lk.window, "n", ":sp<CR>", "Split Horizontal")
	makeDescMap("n", lk.window, "l", "<C-w>l", "Change Window: Left")
	makeDescMap("n", lk.window, "j", "<C-w>j", "Change Window: Down")
	makeDescMap("n", lk.window, "k", "<C-w>k", "Change Window: Up")
	makeDescMap("n", lk.window, "h", "<C-w>h", "Change Window: Right")
	makeDescMap("n", lk.window, "L", "<C-w>L", "Move Window: Left")
	makeDescMap("n", lk.window, "J", "<C-w>J", "Move Window: Down")
	makeDescMap("n", lk.window, "K", "<C-w>K", "Move Window: Up")
	makeDescMap("n", lk.window, "H", "<C-w>H", "Move Window: Right")
	makeDescMap("n", lk.window, "d", "<C-d>", "Scroll Window: Up")
	makeDescMap("n", lk.window, "u", "<C-u>", "Scroll Window: Right")
	makeDescMap("n", lk.write, "v", ":vsplit<CR>", "Split Vertical")
	makeDescMap("n", lk.write, "n", ":sp<CR>", "Split Horizontal")
	makeDescMap("n", lk.write, "l", "<C-w>l", "Change Window: Left")
	makeDescMap("n", lk.write, "j", "<C-w>j", "Change Window: Down")
	makeDescMap("n", lk.write, "k", "<C-w>k", "Change Window: Up")
	makeDescMap("n", lk.write, "h", "<C-w>h", "Change Window: Right")
	makeDescMap("n", lk.write, "L", "<C-w>L", "Move Window: Left")
	makeDescMap("n", lk.write, "J", "<C-w>J", "Move Window: Down")
	makeDescMap("n", lk.write, "K", "<C-w>K", "Move Window: Up")
	makeDescMap("n", lk.write, "H", "<C-w>H", "Move Window: Right")
	makeDescMap("n", lk.write, "d", "<C-d>", "Scroll Window: Up")
	makeDescMap("n", lk.write, "u", "<C-u>", "Scroll Window: Right")
	makeDescMap({"n", "v"}, lk.window_tab, "H", ":tabfirst<CR>", "Tab First")
	makeDescMap({"n", "v"}, lk.window_tab, "L", ":tablast<CR>", "Tab Last")
	makeDescMap({"n", "v"}, lk.window_tab, "l", ":tabn<CR>", "Tab Next")
	makeDescMap({"n", "v"}, lk.window_tab, "h", ":tabp<CR>", "Tab Previous")
	makeDescMap({"n", "v"}, lk.window_tab, "q", ":tabc<CR>", "[Q]uit tab")
	makeDescMap({"n", "v"}, lk.window_tab, "o", ":tabo<CR>", "Tab Open")
	makeDescMap({"n", "v"}, lk.window_tab, "n", ":tabnew<CR>", "[N]ew Tab")
end
--------------------------------

return M
