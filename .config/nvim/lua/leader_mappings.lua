---------------------------------
-- ##############################-
-- # Leader KeyMappings Config  #  --
-- ##############################-
----------------------------------

-- Note
---------
-- I'll use leader mappings for plugins and super extra goodies
-- however ones I use all the time will be mapped to `<c-` or a specific key
-- This follows the conventions <leader>{plugin key}{command key}
-- I've listed already use leader commands here
-- This is in its own file as I'm adding more functionality to nvim and this means that various functions are beginning to clash on my leader keys
-- I need a way to remap them at a moments notice so I'm naming them rather than using them ad hoc
----------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
-- Module Table
local M = {}
----------

-- Requires
----------
local putils = require("personal_utils")
----------

-- Extra Vars
----------
local tableConcat = putils.tableConcat
----------

-- Functions
----------
-- Saves having to type <leader> over and over again, also creates the assist descriptions as it goes
local l = function(key, desc)
	local full_key = "<leader>" .. key
	return full_key
end

----------

--------------------------------
-- Mappings
--------------------------------

-- System
----------
-- Paste
M.paste = l("p", "System Paste")
-- Quit
M.quit = l("q", "Close & Quit Commands")
M.quit_all = l("qa", "Quit All Commands")
M.quit_buffer = l("qb", "Quit Buffer Commands")
-- Write
M.write = l("w", "File Write Commands")
M.write_quit = l("wq", "Write & Quit Commands")
-- Yank
M.yank = l("y", "System Copy")
-- Run Command
M.sysRun = l("!", "Run System Command")
-- Run Lua Command
M.luaRun = l(":", "Run Lua Command")
----------

-- Help
----------
-- Key Mapping Assist - whichkey: <leader>?
M.assist = l("?", "Mapping Assist")
-- Vim Help
M.vimHelp = l(";", "Vim Help")
----------

-- File Mgmt
----------
-- Files
M.file = l("f", "File & Buffer Options")
-- Tab Management
M.tab = l("t", "Tab Options")
-- Pane Resizing
M.resize = l("r", "Pane Resize")
-- Filetree
M.ftree = "<c-n>"
----------

-- Terminal
----------
-- Terminal
M.terminal = l("a", "Terminal Applications")
----------

-- Code Execution
----------
-- Run Code
M.exec = l("x", "Code Execution")
-- Http Calls
M.exec_http = l("xh", "Http Calls")
-- Test Code
M.exec_test = l("xt", "Testing")
-- Code Coverage
M.exec_test_coverage = l("xtc", "Coverage")
----------

-- Language Server
----------
-- Debugging
M.debug = l("b", "Debug Opts")
M.debug_session = l("bs", "Session")
M.debug_fileView = l("bf", "Debug Views")
M.debug_languageOpts = l("bw", "Language Options")
M.debug_python = l("bP", "Python Options")
-- Code Actions
M.codeAction = l("c", "Code & Diagnostic Actions")
M.codeAction_symbols = l("cs", "Language Server Symbol Options")
M.codeAction_injectedLanguage = l("cl", "Injected Language Options")
M.codeAction_alignment = l("ce", "Code Alignment")
-- Snippets
M.snippet = l("s", "Snippets")
------------

-- Wiki
----------
-- Wiki Commands
M.wiki = l("k", "Wiki Options")
M.wiki_createPage = l("kc", "Create Options")
M.wiki_linkOpts = l("kl", "Link Options")
----------

-- Misc
----------
-- Database
M.database = l("d", "Database")
-- Notebook Functionality
M.notebook = l("n", "Notebooks")
M.notebook_kernel = l("nk", "Notebook Kernel Opts")
M.notebook_insert = l("ni", "Notebook Insert Opts")
M.notebook_run = l("nx", "Notebook Insert Opts")
-- Highlighting Options - Treesitter: <leader>h
M.hl = l("h", "Highlighting")
-- Version Control Commands -- fugitive: <leader>v
M.vcs = l("v", "Version Control")
M.vcs_file = l("vf", "VCS: File Options")
-- Todo Highlights -- todocomments.nvim: <leader>m
M.todo = l("m", "Todos")
-- Self Testing
M.selfTest = l("e", "Self-Testing ([E]xaminations)")
-- Document Creation And Templating
M.docCreation = l("l", "Document Formatting & Creation")
-- Zen Mode
M.zen = l("z", "Zen Mode Toggle")
----------

--------------------------------
-- Key Assistance Table
--------------------------------
M.assistDesc = {
	["]"] = { name = "Go To Next" },
	["["] = { name = "Go To Previous" },
	["<leader>"] = {
		a = { name = "Terminal [A]pplications" },
		b = {
			name = "De[b]ugging",
			f = { name = "Debug Views ([f]iles)" },
			s = { name = "[S]essions" },
			w = { name = "Language Options ([w]idgets)" },
			P = { name = "[P]ython" },
		},
		c = { name = "[C]ode Actions & Opts" },
		d = { name = "[D]atabase" },
		e = { name = "[E]xaminations" },
		f = { name = "Telescope & [F]ile Opts" },
		h = { name = "[H]ighlighting Options" },
		k = {
			name = "Wiki Opts ([k]nowledge)",
			c = { name = "[C]reation Opts" },
			l = { name = "[L]ink Opts" },
		},
		l = { name = "VimTex" },
		m = { name = "Todos ([m]essages)" },
		n = {
			name = "[N]otebooks",
			k = { name = "Notebook [K]ernel Opts" },
			i = { name = "[I]nsert Cells Opts" },
			x = { name = "[R]un Cells Opts" },
		},
		p = { name = "System [P]aste" },
		q = {
			name = "Close and [Q]uit",
			b = { name = "Quit [B]uffer Options" },
			a = { name = "Quit [A]ll Options" },
		},
		r = { name = "Pane [R]esizing" },
		s = { name = "[S]nippets" },
		t = { name = "[T]abs Opts" },
		v = { name = "[V]ersion Control", f = { "Telescope Opts ([f]iles)" } },
		w = { name = "File Write", q = { name = "Write & [Q]uit Opts" } },
		x = {
			name = "Code E[x]ecute",
			h = { name = "[H]ttp" },
			t = { name = "[T]esting", c = { name = "[C]overage" } },
		},
		y = { name = "System Copy ([y]ank)" },
    z = { name = "[z]en mode" }
	},
}
--------------------------------

return M
