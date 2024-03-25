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
-- Write
M.write = l("w", "File Write Commands")
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
-- Filetree
M.ftree = "<c-n>"
----------

-- Terminal
----------
-- Toggle
M.terminal = l("t", "Terminal Toggle")
-- Apps
M.terminalApp = l("a", "Terminal Applications")
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
M.nb = l("n", "Notebooks")
-- Highlighting Options - Treesitter: <leader>h
M.hl = l("h", "Highlighting")
-- Version Control Commands -- fugitive: <leader>v
M.vcs = l("v", "Version Control")
M.vcs_file = l("vf", "VCS: File Options")
-- Todo Highlights -- todocomments.nvim: <leader>m
M.todo = l("m", "Todos")
-- Self Testing
M.selfTest = l("r", "Self-Testing (Flashcards)")
-- Document Creation And Templating
M.docCreation = l("l", "Document Formatting & Creation")
----------

--------------------------------
-- Key Assistance Table
--------------------------------
M.assistDesc = {
	["<leader>"] = {
		a = { name = "Terminal Applications" },
		b = {
			name = "Debugging",
			f = { name = "Debug Views" },
			s = { name = "Sessions" },
			w = { name = "Language Options" },
			P = { name = "Python" },
		},
		c = { name = "LSP Opts" },
		d = { name = "Database" },
		f = { name = "Telescope" },
		h = { name = "Highlighting Options" },
		k = {
			name = "Wiki Opts",
			c = { name = "Creation Opts" },
			l = { name = "Link Opts" },
		},
		l = { name = "VimTex" },
		m = { name = "Todos" },
		n = { name = "Notebooks" },
		p = { name = "System Paste" },
		q = {
			name = "Close and Quit",
			b = { name = "Quit Buffer Options" },
			a = { name = "Quit All Options" },
		},
		r = { name = "Flashcards" },
		s = { name = "Snippets" },
		v = { name = "Version Control", f = { "Telescope Options" } },
		w = { name = "File Write", q = { name = "Write & Quit Opts" } },
		x = {
			name = "Code Execute",
			h = { name = "Http" },
			t = { name = "Testing", c = { name = "Coverage" } },
		},
		y = { name = "System Copy" },
	},
}
--------------------------------

return M
