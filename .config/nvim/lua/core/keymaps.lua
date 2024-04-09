
local M = {}

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
-- Module Table
local M = {}
----------

-- Functions
----------
-- Saves having to type <leader> over and over again, also creates the assist descriptions as it goes
local l = function(key, desc)
	local full_key = "<leader>" .. key
	return { key =  full_key, desc =  desc }
end
----------

M.leaderkeys = {
-- System
----------
paste = l("p", "System Paste"),
quit = l("q", "Close & Quit Commands"),
quit_all = l("qa", "Quit All Commands"),
quit_buffer = l("qb", "Quit Buffer Commands"),
write = l("w", "File Write Commands"),
write_quit = l("wq", "Write & Quit Commands"),
yank = l("y", "System Copy"),
sysRun = l("!", "Run System Command"),
luaRun = l(":", "Run Lua Command"),
-- Help
assist = l("?", "Mapping Assist"),
vimHelp = l(";", "Vim Help"),
-- File Mgmt
file = l("f", "File & Buffer Options"),
tab = l("t", "Tab Options"),
resize = l("r", "Pane Resize"),
ftree = "<c-n>",
-- Terminal
terminal = l("a", "Terminal Applications"),
-- Run Code
exec = l("x", "Code Execution"),
exec_http = l("xh", "Http Calls"),
exec_test = l("xt", "Testing"),
exec_test_coverage = l("xtc", "Coverage"),
-- Language Server
----------
-- Debugging
debug = l("b", "Debug Opts"),
debug_session = l("bs", "Session"),
debug_fileView = l("bf", "Debug Views"),
debug_languageOpts = l("bw", "Language Options"),
debug_python = l("bP", "Python Options"),
codeAction = l("c", "Code & Diagnostic Actions"),
codeAction_symbols = l("cs", "Language Server Symbol Options"),
codeAction_injectedLanguage = l("cl", "Injected Language Options"),
codeAction_alignment = l("ce", "Code Alignment"),
snippet = l("s", "Snippets"),
------------
-- Wiki
----------
wiki = l("k", "Wiki Options"),
wiki_createPage = l("kc", "Create Options"),
wiki_linkOpts = l("kl", "Link Options"),
----------
-- Misc
----------
-- Database
database = l("d", "Database"),
-- Notebook Functionality
notebook = l("n", "Notebooks"),
notebook_kernel = l("nk", "Notebook Kernel Opts"),
notebook_insert = l("ni", "Notebook Insert Opts"),
notebook_run = l("nx", "Notebook Insert Opts"),
-- Highlighting Options - Treesitter: <leader>h
hl = l("h", "Highlighting"),
-- Version Control Commands -- fugitive: <leader>v
vcs = l("v", "Version Control"),
vcs_file = l("vf", "VCS: File Options"),
-- Todo Highlights -- todocomments.nvim: <leader>m
todo = l("m", "Todos"),
-- Self Testing,
selfTest = l("e", "Self-Testing ([E]xaminations)"),
-- Document Creation And Templating,
docCreation = l("l", "Document Formatting & Creation"),
-- Zen Mode
zen = l("z", "Zen Mode Toggle"),
----------

}

lk = M.leaderkeys

--------------------------------
-- Key Mappings Table Normal
--------------------------------
M.keymaps_n = {
    	["]"] = { name = "Go To Next" },
    	["["] = { name = "Go To Previous" },
    	["U"] = { ":redo<CR>", "Redo" },
    	["<c-.>"] = {"<c-t>", "Tab forwards" },
    	["<c-,>"] = {"<c-d>", "Tab Backwards" },
    	[ "K" ] = { "H", "Top of Page" },
    	[ "J" ] = { "L", "Bottom of Page" },
    	[ "H" ] = { "0", "Start of Line" },
    	[ "L" ] = { "$", "End of Line" },
    	["0"] = { "K" },
    	["$"] = { "J" },
    	["dL"] = { "d$" },
    	["dH"] = { "d0" },
    	["yH"] = { "y0" },
    	["yL"] = { "y$" },
    	["<C-e>"] = { "5<c-e>" },
    	["<C-y>"] = { "5<c-y>" },
    	["<cr>"]  = { ":nohlsearch<CR>", ""},
    	[ "n"] = { ":set hlsearch<CR>n", "" },
    	[ "N" ] = { ":set hlsearch<CR>N", "" },
    	[ lk.file.key ] = {
    	    name = lk.file.desc,
    	    l = { "<cmd>bnext<CR>", "NextBuff" },
    	    h = { "<cmd>bprev<CR>", "PrevBuff" },
    	},
    	[ lk.terminal.key ] = { name = lk.terminal.desc },
    	[ lk.debug.key ] = { name = lk.debug.desc },
    	[ lk.debug_fileView.key ] = { name = lk.debug_fileView.desc },
    	[ lk.debug_session.key ] =  { name = lk.debug_session.desc },
    	[ lk.debug_languageOpts.key ] = { name = lk.debug_languageOpts.desc },
    	[ lk.debug_python.key ] = { name = lk.debug_python.desc },
    	[ lk.codeAction.key ] = { name = lk.codeAction.desc },
    	[ lk.codeAction_symbols.key ] = { name = lk.codeAction_symbols.desc },
    	[ lk.codeAction_injectedLanguage.key ] = { name = lk.codeAction_injectedLanguage.desc },
    	[ lk.codeAction_alignment.key ] = { name = lk.codeAction_alignment.desc },
    	[ lk.database.key ] = { name = lk.database.desc },
    	[ lk.selfTest.key ] = { name = lk.selfTest.desc },
    	[ lk.file.key ] = { name = lk.file.desc },
    	[ lk.hl.key ] = { name = lk.hl.desc },
    	[ lk.wiki.key ] = { name = lk.wiki.desc },
    	[ lk.wiki_createPage.key ] = { name = lk.wiki_createPage.desc },
    	[ lk.wiki_linkOpts.key ] = { name = lk.wiki_linkOpts.desc },
    	[ lk.docCreation.key ] = { name = lk.docCreation.desc },
    	[ lk.todo.key ] = { name = lk.todo.desc },
    	[ lk.notebook.key ] = { name = lk.notebook.desc },
    	[ lk.notebook_kernel.key ] = { name = lk.notebook_kernel.desc },
    	[ lk.notebook_insert.key ] = { name = lk.notebook_insert.desc },
    	[ lk.notebook_run.key ] = { name = lk.notebook_run.desc },
	[ lk.resize.key] = { name = lk.resize.desc },
	[ lk.snippet.key] = { name = lk.snippet.desc },
	[ lk.tab.key] = { name = lk.tab.desc },
	[ lk.vcs.key] = { name = lk.vcs.desc },
	[ lk.vcs_file.key] = { name = lk.vcs_file.desc },
	[ lk.exec.key] = { name = lk.exec.desc },
	[ lk.exec_http.key] = { name = lk.exec_http.desc },
	[ lk.exec_test.key] = { name = lk.exec_test.desc },
	[ lk.exec_test_coverage.key] = { name = lk.exec_test_coverage.desc },
	[ lk.write.key ] = { name = lk.write.desc,
            w = { ":w<CR>", "Write" },
            [ "!" ] = { ":w!<CR>", "Over-write" },
            s = { ":so<CR>", "Write and Source to Nvim" },
            a = { ":wa<CR>", "Write All" },
        },
        [ lk.write_quit.key ] = { name = lk.write_quit.desc,
            q = { ":wq<CR>", "Close Buffer"},
            b = { ":w<CR>:bd<CR>", "Write and Close Buffer w/o Pane"},
            a = { ":wqa<CR>", "Write All & Quit Nvim"},
        },
	[ lk.quit.key ] = { name = lk.quit.desc,
            q = { ":q<CR>", "Close Buffer and Pane"},
            ["!"] = { ":q!<CR>", "Close Buffer Without Writing"},
        },
        [ lk.quit_buffer.key ] = { name =  lk.quit_buffer.desc,
            b = { ":bd<CR>", "Close Buffer w/o Pane"},
	    ["!"] = { ":bd<CR>", "Close Buffer w/o Pane"},
        },
	[ lk.quit_all.key ] = { name = lk.quit_all.desc,
            a = {":qa<CR>", "Quit Nvim"},
            ["!"] = {"<cmd>qa!<cr>", "Quit Nvim Without Writing"}
        },
	[ lk.yank.key ] = { name = lk.yank.desc,
		v = { '"+y', "System Copy" },
		y = {'"+yy', "System Copy: Line" },
		G = { '"+yG', "System Copy: Rest of File" },
		[ "%" ] = { '"+y%', "System Copy: Whole of File" },
	},
	[ lk.paste.key ] =  { '"+p',  "System Paste" },
	[ lk.resize.key ] = { name = lk.resize.desc,
		j = { "<c-\\><c-n>:res-5<CR>i",  "Move Partition Down" },
		k = { "<c-\\><c-n>:res+5<CR>i",  "Move Partition Up" },
	  	h = { "<c-\\><c-n>:vertical resize -5<CR>i", "Move Partition Left" },
	  	l = { "<c-\\><c-n>:vertical resize +5<CR>i", "Move Partition Right" }
  	},
	[ lk.tab.key ] = { name = lk.tab.desc,
 		H = { ":tabfirst<cr>", "Tab First" },
 		L = { ":tablast<cr>", "Tab Last" },
 		l = { ":tabn<cr>", "Tab Next" },
 		h = { ":tabp<cr>", "Tab Previous" },
		q = { ":tabc<cr>", "[Q]uit tab" },
		o = { ":tabo<cr>", "Tab Open" },
		n = { ":tabnew<cr>", "[N]ew Tab" },
	},
        [ lk.zen.key ] = { name = lk.zen.desc },
}
--------------------------------

--------------------------------
-- Key Mappings Table Visual
--------------------------------

M.keymaps_v = {
    ["<C-e>"] = { "5<c-e>" },
    ["<C-y>"] = { "5<c-y>" },
    [ "K" ] = { "H", "Top of Page" },
    [ "J" ] = { "L", "Bottom of Page" },
    [ "H" ] = { "0", "Start of Line" },
    [ "L" ] = { "$", "End of Line" },
    [ "<leader>/" ] = { '"fy/\\V<C-R>f<CR>' },
    [ lk.yank.key ] = { name = lk.yank.desc,
    	v = { '"+y', "System Copy" },
    	y = {'"+yy', "System Copy: Line" },
    	G = { '"+yG', "System Copy: Rest of File" },
    	[ "%" ] = { '"+y%', "System Copy: Whole of File" },
    },
   [ lk.paste.key ] =  { '"+p',  "System Paste" },
   [ lk.resize.key ] = { name = lk.resize.desc,
   	j = { "<c-\\><c-n>:res-5<CR>i",  "Move Partition Down" },
   	k = { "<c-\\><c-n>:res+5<CR>i",  "Move Partition Up" },
   	h = { "<c-\\><c-n>:vertical resize -5<CR>i", "Move Partition Left" },
   	l = { "<c-\\><c-n>:vertical resize +5<CR>i", "Move Partition Right" }
   },
   [ lk.tab.key ] = { name = lk.tab.desc,
   	H = { ":tabfirst<cr>", "Tab First" },
   	L = { ":tablast<cr>", "Tab Last" },
   	l = { ":tabn<cr>", "Tab Next" },
   	h = { ":tabp<cr>", "Tab Previous" },
   	q = { ":tabc<cr>", "[Q]uit tab" },
   	o = { ":tabo<cr>", "Tab Open" },
   	n = { ":tabnew<cr>", "[N]ew Tab" },
   },
}

--------------------------------
-- Key Mappings Table Insert
--------------------------------

M.keymaps_i = {
    ["<c-.>"] = {"<c-t>", "Tab forwards" },
    ["<c-,>"] = {"<c-d>", "Tab Backwards" },
    [ lk.resize.key ] = { name = lk.resize.desc,
   	j = { "<c-\\><c-n>:res-5<CR>i",  "Move Partition Down" },
   	k = { "<c-\\><c-n>:res+5<CR>i",  "Move Partition Up" },
   	h = { "<c-\\><c-n>:vertical resize -5<CR>i", "Move Partition Left" },
   	l = { "<c-\\><c-n>:vertical resize +5<CR>i", "Move Partition Right" }
    },
    [ lk.tab.key ] = { name = lk.tab.desc,
       	H = { ":tabfirst<cr>", "Tab First" },
       	L = { ":tablast<cr>", "Tab Last" },
       	l = { ":tabn<cr>", "Tab Next" },
       	h = { ":tabp<cr>", "Tab Previous" },
       	q = { ":tabc<cr>", "[Q]uit tab" },
       	o = { ":tabo<cr>", "Tab Open" },
       	n = { ":tabnew<cr>", "[N]ew Tab" },
    },
}

--------------------------------
-- Key Mappings Table Terminal
--------------------------------

M.keymaps_t = {
    [ lk.resize.key ] = { name = lk.resize.desc,
   	j = { "<c-\\><c-n>:res-5<CR>i",  "Move Partition Down" },
   	k = { "<c-\\><c-n>:res+5<CR>i",  "Move Partition Up" },
   	h = { "<c-\\><c-n>:vertical resize -5<CR>i", "Move Partition Left" },
   	l = { "<c-\\><c-n>:vertical resize +5<CR>i", "Move Partition Right" }
    },
    [ lk.tab.key ] = { name = lk.tab.desc,
           	H = { ":tabfirst<cr>", "Tab First" },
           	L = { ":tablast<cr>", "Tab Last" },
           	l = { ":tabn<cr>", "Tab Next" },
           	h = { ":tabp<cr>", "Tab Previous" },
           	q = { ":tabc<cr>", "[Q]uit tab" },
           	o = { ":tabo<cr>", "Tab Open" },
           	n = { ":tabnew<cr>", "[N]ew Tab" },
    },
}


--------------------------------
-- Key Mappings Table Command
--------------------------------

M.keymaps_c = {
    [ lk.resize.key ] = { name = lk.resize.desc,
   	j = { "<c-\\><c-n>:res-5<CR>i",  "Move Partition Down" },
   	k = { "<c-\\><c-n>:res+5<CR>i",  "Move Partition Up" },
   	h = { "<c-\\><c-n>:vertical resize -5<CR>i", "Move Partition Left" },
   	l = { "<c-\\><c-n>:vertical resize +5<CR>i", "Move Partition Right" }
    },
    [ lk.tab.key ] = { name = lk.tab.desc,
           	H = { ":tabfirst<cr>", "Tab First" },
           	L = { ":tablast<cr>", "Tab Last" },
           	l = { ":tabn<cr>", "Tab Next" },
           	h = { ":tabp<cr>", "Tab Previous" },
           	q = { ":tabc<cr>", "[Q]uit tab" },
           	o = { ":tabo<cr>", "Tab Open" },
           	n = { ":tabnew<cr>", "[N]ew Tab" },
    },
}

return M
