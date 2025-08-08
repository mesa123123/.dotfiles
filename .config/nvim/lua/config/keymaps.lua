------------------------------
-- ###################### --
-- #   Key Map Options  # --
-- ###################### --
--------------------------------

-- Module
----------
local M = {}
----------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Functions
----------
-- Saves having to type <leader> over and over again, also creates the assist descriptions as it goes
-- This creates a telescope help message that behaves how I want it to
M.telescope_help = function()
  if pcall(require, "telescope") then
    return require("telescope.builtin").help_tags({
      results_title = "Help Tags",
      theme = "dropdown",
      attach_mappings = function(_, map)
        map("i", "<CR>", function(prompt_bufnr)
          local action_state = require("telescope.actions.state")
          local actions = require("telescope.actions")
          local selected_entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selected_entry then
            vim.cmd("rightbelow vert help " .. selected_entry.value)
          end
        end)
        return true
      end,
    })
  end
  return vim.cmd(":h ")
end
-- Dark Mode Toggle
M.toggle_dark_mode = function()
  local bg_setting = vim.o.bg
  if bg_setting == "dark" then
    vim.notify("Light Mode")
    vim.o.bg = "light"
  else
    vim.notify("Dark Mode")
    vim.o.bg = "dark"
  end
end
-- Get filename in clipboard
M.local_filepath_clip = function()
  local filepath = vim.fn.expand("%:p")
  vim.fn.setreg("+", filepath)
  vim.print("Current file path copied to clipboard: " .. filepath)
end
----------

--------------------------------
-- Leader Keys
--------------------------------

-- Setup Leader Key Table
----------
-- Setup Function
M.l = function(key, desc)
  local full_key = "<leader>" .. key
  return { key = full_key, desc = desc }
end
-- Leader Tables
M.lk = {
  ai = M.l("a", "Ai Assistant"),
  buffer_explorer = M.l("fb", "Buffer Options"),
  codeAction = M.l("c", "Code & Diagnostic Actions"),
  codeAction_symbols = M.l("cs", "Language Server Symbol Options"),
  codeAction_injectedLanguage = M.l("cL", "Injected Language Options"),
  codeAction_format = M.l("cf", "LSP: Format Code"),
  codeAction_lint = M.l("cl", "LSP: Lint Code"),
  codeAction_alignment = M.l("ce", "Code Alignment"),
  database = M.l("d", "Database"),
  debug = M.l("b", "Debug Opts"),
  debug_session = M.l("bs", "Session"),
  debug_fileView = M.l("bf", "Debug Views"),
  debug_languageOpts = M.l("bw", "[D]ebug [L]anguage Options"),
  debug_config = M.l("ba", "[D]ebug [A]rranger"),
  exec = M.l("x", "Code Execution"),
  exec_http = M.l("xh", "Http Calls"),
  exec_test = M.l("xt", "Testing"),
  exec_test_coverage = M.l("xtc", "Coverage"),
  explore = M.l("e", "[E]xplore Current File"),
  file = M.l("f", "File & Buffer Options"),
  file_manuals = M.l("fm", "Manuals Options"),
  file_history = M.l("fH", "History Options"),
  file_explorer = M.l("fe", "File Explorer Options"),
  highlights = M.l("h", "Color/[H]ighlight Opts"),
  luaRun = M.l(":", "Run Lua Command"),
  assist = M.l("?", "Mapping Assist"),
  notebook = M.l("n", "Notebooks"),
  notebook_kernel = M.l("nk", "Notebook Kernel Opts"),
  notebook_insert = M.l("ni", "Notebook Insert Opts"),
  notebook_run = M.l("nx", "Notebook Insert Opts"),
  paste = M.l("p", "System Paste"),
  quit = M.l("q", "Close & Quit Commands"),
  quit_all = M.l("qa", "Quit All Commands"),
  quit_buffer = M.l("qb", "Quit Buffer Commands"),
  resize = M.l("r", "Pane Resize"),
  snippet = M.l("s", "Snippets"),
  spell = M.l("z", "Spell Check"),
  sysRun = M.l("!", "Run System Command"),
  tab = M.l("t", "Tab Options"),
  terminal = M.l("A", "Terminal Applications"),
  todo = M.l("m", "Todos"),
  uniqueft = M.l("u", "[U]nique to this format"),
  vcs = M.l("v", "Version Control"),
  vcs_file = M.l("vf", "VCS: File Options"),
  vimHelp = M.l(";", "Vim Help"),
  wiki = M.l("k", "Wiki Options"),
  wiki_createPage = M.l("kc", "Create Options"),
  wiki_linkOpts = M.l("kl", "Link Options"),
  window = M.l("w", "Window Options"),
  write = M.l("w", "File Write Commands"),
  write_quit = M.l("wq", "Write & Quit Commands"),
  yank = M.l("y", "System Copy"),
}
----------

--------------------------------
-- Key Mappings Setup
--------------------------------
M.setup = function()
  local makeDescMap = require("config.utils").desc_keymap
  local keyopts = require("config.utils").keyopts
  local lk = M.lk
  local makeDesc = function(km)
    vim.keymap.set("n", "" .. km.key .. "", "<CMD>" .. km.key .. "<CR>", { desc = "Opts: " .. km.desc })
  end
  for _, v in pairs(lk) do
    makeDesc(v)
  end
  vim.keymap.set("n", "[", "[", keyopts({ desc = "Go To Previous" }))
  vim.keymap.set("n", "]", "]", keyopts({ desc = "Go To Next" }))
  vim.keymap.set("n", "U", ":redo<CR>", keyopts({ desc = "Redo" }))
  vim.keymap.set({ "n", "i" }, "<c-.>", "<c-t>", keyopts({ desc = "Tab forwards" }))
  vim.keymap.set({ "n", "i" }, "<c-,>", "<c-d>", keyopts({ desc = "Tab Backwards" }))
  vim.keymap.set({ "n", "v" }, "K", "H", keyopts({ desc = "Top of Page" }))
  vim.keymap.set({ "n", "v" }, "J", "L", keyopts({ desc = "Bottom of Page" }))
  vim.keymap.set({ "n", "v" }, "H", "0", keyopts({ desc = "Start of Line" }))
  vim.keymap.set({ "n", "v" }, "L", "$", keyopts({ desc = "End of Line" }))
  vim.keymap.set({ "n", "i", "v", "c" }, "£", "#", keyopts())
  vim.keymap.set({ "n", "i", "v", "c" }, "§", "£", keyopts())
  vim.keymap.set({ "n", "i", "v", "c" }, "f£", "f#", keyopts())
  vim.keymap.set({ "n", "i", "v", "c" }, "F£", "F#", keyopts())
  vim.keymap.set("n", "0", "K", keyopts())
  vim.keymap.set("n", "$", "J", keyopts())
  vim.keymap.set("n", "dL", "d$", keyopts())
  vim.keymap.set("n", "dH", "d0", keyopts())
  vim.keymap.set("n", "yH", "y0", keyopts())
  vim.keymap.set("n", "yL", "y$", keyopts())
  vim.keymap.set({ "n", "v" }, "<C-e>", "5<c-e>", keyopts())
  vim.keymap.set({ "n", "v" }, "<C-y>", "5<c-y>", keyopts())
  vim.keymap.set("n", "<cr>", ":nohlsearch<CR>", keyopts())
  vim.keymap.set("n", "n", ":set hlsearch<CR>n", keyopts())
  vim.keymap.set("n", "N", ":set hlsearch<CR>N", keyopts())
  vim.keymap.set({ "n", "v" }, lk.paste.key, '"+p', keyopts({ desc = lk.paste.desc }))
  makeDescMap({ "n", "v" }, lk.resize, "j", ":res-15<CR>", "Move Partition Down")
  makeDescMap({ "n", "v" }, lk.resize, "k", ":res+15<CR>", "Move Partition Up")
  makeDescMap({ "n", "v" }, lk.resize, "h", ":vertical resize -15<CR>", "Move Partition Left")
  makeDescMap({ "n", "v" }, lk.resize, "l", ":vertical resize +15<CR>", "Move Partition Right")
  makeDescMap({ "n", "v" }, lk.resize, "H", ":vertical resize -60<CR>", "Move Partition Left Bigly")
  makeDescMap({ "n", "v" }, lk.resize, "L", ":vertical resize +60<CR>", "Move Partition Right Bigly")
  makeDescMap({ "n", "v" }, lk.yank, "v", '"+y', "System Copy")
  makeDescMap({ "n", "v" }, lk.yank, "y", '"+yy', "System Copy: Line")
  makeDescMap({ "n", "v" }, lk.yank, "G", '"+yG', "System Copy: Rest of File")
  makeDescMap({ "n", "v" }, lk.yank, "%", '"+y%', "System Copy: Whole of File")
  makeDescMap({ "n", "v" }, lk.highlights, "o", M.toggle_dark_mode, "[C]hange Background Mode")
  makeDescMap("n", lk.file, "l", ":bnext<CR>", "NextBuff")
  makeDescMap("n", lk.file, "h", ":bprev<CR>", "PrevBuff")
  makeDescMap("n", lk.file, "x", ":e new<CR>", "New File")
  makeDescMap("n", lk.file, "p", M.local_filepath_clip, "Filepath to clipboard")
  makeDescMap("n", lk.write, "w", ":w<CR>", "Write")
  makeDescMap("n", lk.write, "!", ":w!<CR>", "Over-write")
  makeDescMap("n", lk.write, "s", ":so<CR>", "Write and Source to Nvim")
  makeDescMap("n", lk.write, "a", ":wa<CR>:lua vim.print('All Saved!')<CR>", "Write All")
  makeDescMap("n", lk.write_quit, "b", ":w<CR>:bd<CR>", "Write and Close Buffer w/o Pane")
  makeDescMap("n", lk.write_quit, "a", ":wqa<CR>", "Write All & Quit Nvim")
  makeDescMap("n", lk.quit, "q", ":q<CR>", "[Q]uit Nvim")
  makeDescMap("n", lk.quit, "!", ":q!<CR>", "Close Buffer Without Writing")
  makeDescMap("n", lk.quit_buffer, "!", ":bd!<CR>", "Close Buffer w/o Pane")
  makeDescMap("n", lk.quit_buffer, "b", ":bd<CR>", "Close Buffer w/o Pane")
  makeDescMap("n", lk.quit_all, "a", ":qa<CR>", "Quit Nvim")
  makeDescMap("n", lk.quit_all, "!", ":qa!<CR>", "Quit Nvim Without Writing")
  makeDescMap("n", lk.window, "v", ":vsplit<CR>", "Split Vertical")
  makeDescMap("n", lk.window, "n", ":sp<CR>", "Split Horizontal")
  makeDescMap("n", lk.window, "l", "<C-w>l", "Change Window: Left")
  makeDescMap("n", lk.window, "j", "<C-w>j", "Change Window: Down")
  makeDescMap("n", lk.window, "k", "<C-w>k", "Change Window: Up")
  makeDescMap("n", lk.window, "h", "<C-w>h", "Change Window: Right")
  makeDescMap("n", lk.window, ";", "<C-u>", "Change Window Next")
  makeDescMap("n", lk.window, "L", "<C-w>L", "Move Window: Left")
  makeDescMap("n", lk.window, "J", "<C-w>J", "Move Window: Down")
  makeDescMap("n", lk.window, "K", "<C-w>K", "Move Window: Up")
  makeDescMap("n", lk.window, "H", "<C-w>H", "Move Window: Right")
  makeDescMap("n", lk.window, "d", "<C-d>", "Scroll Window: Up")
  makeDescMap("n", lk.window, "u", "<C-u>", "Scroll Window: Right")
  makeDescMap({ "n", "v" }, lk.tab, "H", ":tabfirst<CR>", "Tab First")
  makeDescMap({ "n", "v" }, lk.tab, "L", ":tablast<CR>", "Tab Last")
  makeDescMap({ "n", "v" }, lk.tab, "l", ":tabn<CR>", "Tab Next")
  makeDescMap({ "n", "v" }, lk.tab, "h", ":tabp<CR>", "Tab Previous")
  makeDescMap({ "n", "v" }, lk.tab, "q", ":tabc<CR>", "[Q]uit tab")
  makeDescMap({ "n", "v" }, lk.tab, "o", ":tabo<CR>", "Tab Open")
  makeDescMap({ "n", "v" }, lk.tab, "n", ":tabnew<CR>", "[N]ew Tab")
  makeDescMap({ "n" }, lk.exec, "x", ":CompilerOpen<CR>", "E[x]ec Code")
  makeDescMap({ "n" }, lk.exec, "r", ":CompilerStop<CR>:CompilerRedo<CR>", "E[x]ec Re[r]un")
  makeDescMap({ "n" }, lk.exec, "q", ":CompilerStop<CR>", "E[x]ec [Q]uit")
  makeDescMap({ "n" }, lk.exec, "o", ":CompilerToggleResults<CR>", "E[x]ec [O]utput")
  makeDescMap({ "n" }, lk.exec, "o", ":CompilerToggleResults<CR>", "E[x]ec [O]utput")
  makeDescMap({ "n" }, lk.spell, "z", ':lua require("config.utils").toggle_spell_check()<CR>', "Toggle Spell Check")
  makeDescMap({ "n" }, lk.vimHelp, "p", ":lua print(", "Print [L]ua Command")
  makeDescMap({ "n" }, lk.vimHelp, "h", M.telescope_help, "Open [H]elp Reference")
  makeDescMap({ "n" }, lk.vimHelp, "s", ":! ", "Run [S]ystem Command")
  makeDescMap(
    { "v" },
    lk.exec,
    "v",
    ":lua require('config.utils').execute_lua_selection()<CR>",
    "E[x]ec [V]isual Lua Block"
  )
end
--------------------------------

--------------------------------
-- Return Table
--------------------------------

return M

--------------------------------
