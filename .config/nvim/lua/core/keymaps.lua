
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
local utils = require('core.utils')
----------

-- Extra Vars
----------
local nmap = utils.norm_keyset
local keyopts = utils.keyopts
local nlmap = utils.norm_loudkeyset
----------

-- Functions
----------
-- Saves having to type <leader> over and over again, also creates the assist descriptions as it goes
M.l = function(key, desc)
	local full_key = "<leader>" .. key
	return { key =  full_key, desc =  desc }
end
-- Creates a description for menu keys (keys that have sub keys)
M.makeDesc = function(km)
    keymap.set("n", "" .. km.key .. "", "<CMD>" .. km.key .. "<CR>", { desc = km.desc })
end
----------

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
  tab = M.l("t", "Tab Options"),
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
  codeAction_injectedLanguage = M.l("cl", "Injected Language Options"),
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
    lk = M.lk
    for k, v in pairs(lk) do
         M.makeDesc(v)
    end
	keymap.set("n", "[","[", keyopts({ desc = "Go To Previous"}))
	keymap.set("n", "]","]", keyopts({ desc = "Go To Next"}))
	keymap.set("n", "U", "redo", keyopts({ desc =  "Redo"}))
    keymap.set("n", "<c-.>", "<c-t>", keyopts({ desc = "Tab forwards"}))
    keymap.set("n", "<c-,>", "<c-d>", keyopts({ desc = "Tab Backwards"}))
    keymap.set("n",  "K" , "H", keyopts({ desc =  "Top of Page"}))
    keymap.set("n",  "J" , "L", keyopts({ desc =  "Bottom of Page"}))
    keymap.set("n",  "H" , "0", keyopts({ desc =  "Start of Line"}))
    keymap.set("n",  "L" , "$", keyopts({ desc =  "End of Line"}))
    keymap.set("n", "0", "K", keyopts())
    keymap.set("n", "$", "J", keyopts())
    keymap.set("n", "dL", "d$", keyopts())
    keymap.set("n", "dH", "d0", keyopts())
    keymap.set("n", "yH", "y0", keyopts())
    keymap.set("n", "yL", "y$", keyopts())
    keymap.set("n", "<C-e>", "5<c-e>", keyopts())
    keymap.set("n", "<C-y>", "5<c-y>", keyopts())
    keymap.set("n", "<cr>", ":nohlsearch<CR>", keyopts())
    keymap.set("n", "n", ":set hlsearch<CR>n", keyopts())
    keymap.set("n", "N" , ":set hlsearch<CR>N", keyopts())
 	keymap.set("n", lk.resize.key  .. "j" , ":res-5<CR>", keyopts({ desc =  "Move Partition Down"}))
 	keymap.set("n", lk.resize.key  .. "k" , ":res+5<CR>", keyopts({ desc =  "Move Partition Up"}))
 	keymap.set("n", lk.resize.key  .. "h" , ":vertical resize -5<CR>", keyopts({ desc = "Move Partition Left"}))
 	keymap.set("n", lk.resize.key  .. "l" , ":vertical resize +5<CR>", keyopts({ desc = "Move Partition Right"}))
    nmap(lk.file.key .. "l", "bnext", "NextBuff")
    nmap(lk.file.key .. "h", "bprev", "PrevBuff")
    nmap(lk.write.key ..  "w", "w", "Write")
    nmap(lk.write.key .. "!", "w!", "Over-write")
    nmap(lk.write.key .. "s", "so", "Write and Source to Nvim")
    nmap(lk.write.key .. "a", "wa", "Write All")
    nmap(lk.write_quit.key .. "q", "wq", "Close Buffer")
    nmap(lk.write_quit.key ..  "b","w<CR>:bd", "Write and Close Buffer w/o Pane")
    nmap(lk.write_quit.key .. "a", "wqa", "Write All & Quit Nvim")
    nmap(lk.quit.key .."q", "q", "Close Buffer and Pane")
    nmap(lk.quit.key .."!", "q!", "Close Buffer Without Writing")
    nmap(lk.quit_buffer.key .. "b", "bd", "Close Buffer w/o Pane")
 	nmap(lk.quit_buffer.key .. "!","bd", "Close Buffer w/o Pane")
    nmap(lk.quit_all.key .. "a", "qa", "Quit Nvim")
    nmap(lk.quit_all.key .. "!", "qa!", "Quit Nvim Without Writing")
 	nmap(lk.yank.key .. "v",  '"+y', "System Copy" )
 	nmap(lk.yank.key .. "y", '"+yy', "System Copy: Line" )
    nmap(lk.yank.key .. "G",  '"+yG', "System Copy: Rest of File" )
    nmap(lk.yank.key .. "%",  '"+y%', "System Copy: Whole of File" )
 	nmap(lk.paste.key, '"+p',  "System Paste" )
  	nmap(lk.tab.key  .. "H" , ":tabfirst", "Tab First" )
  	nmap(lk.tab.key  .. "L" , ":tablast", "Tab Last" )
  	nmap(lk.tab.key  .. "l" , ":tabn", "Tab Next" )
  	nmap(lk.tab.key  .. "h" , ":tabp", "Tab Previous" )
 	nmap(lk.tab.key  .. "q" , ":tabc", "[Q]uit tab" )
 	nmap(lk.tab.key  .. "o" , ":tabo", "Tab Open" )
 	nmap(lk.tab.key  .. "n" , ":tabnew", "[N]ew Tab" )
end
--------------------------------

-- --------------------------------
-- -- Key Mappings Table Visual
-- --------------------------------
-- 
-- M.keymaps_v = {
--     ["<C-e>"] = { "5<c-e>" },
--     ["<C-y>"] = { "5<c-y>" },
--     [ "K" ] = { "H", "Top of Page" },
--     [ "J" ] = { "L", "Bottom of Page" },
--     [ "H" ] = { "0", "Start of Line" },
--     [ "L" ] = { "$", "End of Line" },
--     [ "<leader>/" ] = { '"fy/\\V<C-R>f<CR>' },
--     [ lk.yank.key ] = { name = lk.yank.desc,
--     	v = { '"+y', "System Copy" },
--     	y = {'"+yy', "System Copy: Line" },
--     	G = { '"+yG', "System Copy: Rest of File" },
--     	[ "%" ] = { '"+y%', "System Copy: Whole of File" },
--     },
--    [ lk.paste.key ] =  { '"+p',  "System Paste" },
--    [ lk.resize.key ] = { name = lk.resize.desc,
--    	j = { "<c-\\><c-n>:res-5<CR>i",  "Move Partition Down" },
--    	k = { "<c-\\><c-n>:res+5<CR>i",  "Move Partition Up" },
--    	h = { "<c-\\><c-n>:vertical resize -5<CR>i", "Move Partition Left" },
--    	l = { "<c-\\><c-n>:vertical resize +5<CR>i", "Move Partition Right" }
--    },
--    [ lk.tab.key ] = { name = lk.tab.desc,
--    	H = { ":tabfirst<cr>", "Tab First" },
--    	L = { ":tablast<cr>", "Tab Last" },
--    	l = { ":tabn<cr>", "Tab Next" },
--    	h = { ":tabp<cr>", "Tab Previous" },
--    	q = { ":tabc<cr>", "[Q]uit tab" },
--    	o = { ":tabo<cr>", "Tab Open" },
--    	n = { ":tabnew<cr>", "[N]ew Tab" },
--    },
-- }
-- 
-- --------------------------------
-- -- Key Mappings Table Insert
-- --------------------------------
-- 
-- M.keymaps_i = {
--     ["<c-.>"] = {"<c-t>", "Tab forwards" },
--     ["<c-,>"] = {"<c-d>", "Tab Backwards" },
--     [ lk.resize.key ] = { name = lk.resize.desc,
--    	j = { "<c-\\><c-n>:res-5<CR>i",  "Move Partition Down" },
--    	k = { "<c-\\><c-n>:res+5<CR>i",  "Move Partition Up" },
--    	h = { "<c-\\><c-n>:vertical resize -5<CR>i", "Move Partition Left" },
--    	l = { "<c-\\><c-n>:vertical resize +5<CR>i", "Move Partition Right" }
--     },
--     [ lk.tab.key ] = { name = lk.tab.desc,
--        	H = { ":tabfirst<cr>", "Tab First" },
--        	L = { ":tablast<cr>", "Tab Last" },
--        	l = { ":tabn<cr>", "Tab Next" },
--        	h = { ":tabp<cr>", "Tab Previous" },
--        	q = { ":tabc<cr>", "[Q]uit tab" },
--        	o = { ":tabo<cr>", "Tab Open" },
--        	n = { ":tabnew<cr>", "[N]ew Tab" },
--     },
-- }
-- 
-- --------------------------------
-- -- Key Mappings Table Terminal
-- --------------------------------
-- 
-- M.keymaps_t = {
--     [ "" .. M.lk.resize.key .. "" ] = { name = "" .. M.lk.resize.desc .. "",
--    	j = { "<c-\\><c-n>:res-5<CR>i",  "Move Partition Down" },
--    	k = { "<c-\\><c-n>:res+5<CR>i",  "Move Partition Up" },
--    	h = { "<c-\\><c-n>:vertical resize -5<CR>i", "Move Partition Left" },
--    	l = { "<c-\\><c-n>:vertical resize +5<CR>i", "Move Partition Right" }
--     },
--     [ "" .. M.lk.tab.key .. "" ] = { name = "" ..  M.lk.tab.desc .. "",
--            	H = { ":tabfirst<cr>", "Tab First" },
--            	L = { ":tablast<cr>", "Tab Last" },
--            	l = { ":tabn<cr>", "Tab Next" },
--            	h = { ":tabp<cr>", "Tab Previous" },
--            	q = { ":tabc<cr>", "[Q]uit tab" },
--            	o = { ":tabo<cr>", "Tab Open" },
--            	n = { ":tabnew<cr>", "[N]ew Tab" },
--     },
-- }
-- 
-- 
-- --------------------------------
-- -- Key Mappings Table Command
-- --------------------------------
-- 
-- M.keymaps_c = {
--     [ lk.resize.key ] = { name = lk.resize.desc,
--    	j = { "<c-\\><c-n>:res-5<CR>i",  "Move Partition Down" },
--    	k = { "<c-\\><c-n>:res+5<CR>i",  "Move Partition Up" },
--    	h = { "<c-\\><c-n>:vertical resize -5<CR>i", "Move Partition Left" },
--    	l = { "<c-\\><c-n>:vertical resize +5<CR>i", "Move Partition Right" }
--     },
--     [ lk.tab.key ] = { name = lk.tab.desc,
--            	H = { ":tabfirst<cr>", "Tab First" },
--            	L = { ":tablast<cr>", "Tab Last" },
--            	l = { ":tabn<cr>", "Tab Next" },
--            	h = { ":tabp<cr>", "Tab Previous" },
--            	q = { ":tabc<cr>", "[Q]uit tab" },
--            	o = { ":tabo<cr>", "Tab Open" },
--            	n = { ":tabnew<cr>", "[N]ew Tab" },
--     },
-- }

return M
