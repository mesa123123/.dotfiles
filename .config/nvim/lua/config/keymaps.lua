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
-- Arg list Nav
M.nav_arglist = function(count)
  local arglen = vim.fn.argc()
  if arglen == 0 then
    return
  end
  local current_idx = vim.fn.argidx()
  local next_idx = (current_idx + count) % arglen
  if next_idx < 0 then
    next_idx = next_idx + arglen
  end
  vim.cmd(string.format("%darg", next_idx + 1))
  vim.cmd("args")
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
  argument_files = M.l("fa", "Arguemnt File Options"),
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
-- Make Leader Key Descriptions
--------------------------------

M.get_leader_descriptions = function()
  local leader_descriptions = function(mode, prefix)
    local clues = {}
    for _, v in pairs(M.lk) do
      table.insert(clues, { mode = mode, key = prefix .. v.key, desc = "+" .. v.desc })
    end
    return clues
  end
  return leader_descriptions("n", vim.g["mapleader"])
end

--------------------------------
-- Key Mappings Setup
--------------------------------
M.setup = function()
  local makeDescMap = require("config.utils").desc_keymap
  local keyopts = require("config.utils").keyopts
  local lk = M.lk
  local keymap = vim.keymap.set
  keymap("n", "[", "[", keyopts({ desc = "Go To Previous" }))
  keymap("n", "]", "]", keyopts({ desc = "Go To Next" }))
  keymap("n", "U", ":redo<CR>", keyopts({ desc = "Redo" }))
  keymap({ "n", "i" }, "<c-.>", "<c-t>", keyopts({ desc = "Tab forwards" }))
  keymap({ "n", "i" }, "<c-,>", "<c-d>", keyopts({ desc = "Tab Backwards" }))
  keymap({ "n", "v" }, "K", "H", keyopts({ desc = "Top of Page" }))
  keymap({ "n", "v" }, "J", "L", keyopts({ desc = "Bottom of Page" }))
  keymap({ "n", "v" }, "H", "0", keyopts({ desc = "Start of Line" }))
  keymap({ "n", "v" }, "L", "$", keyopts({ desc = "End of Line" }))
  keymap({ "n", "i", "v", "c" }, "£", "#", keyopts())
  keymap({ "n", "i", "v", "c" }, "§", "£", keyopts())
  keymap({ "n", "i", "v", "c" }, "f£", "f#", keyopts())
  keymap({ "n", "i", "v", "c" }, "F£", "F#", keyopts())
  keymap("n", "0", "K", keyopts())
  keymap("n", "$", "J", keyopts())
  keymap("n", "dL", "d$", keyopts())
  keymap("n", "dH", "d0", keyopts())
  keymap("n", "yH", "y0", keyopts())
  keymap("n", "yL", "y$", keyopts())
  keymap({ "n", "v" }, "<C-e>", "5<c-e>zz", keyopts())
  keymap({ "n", "v" }, "<C-y>", "5<c-y>zz", keyopts())
  keymap("n", "<cr>", ":nohlsearch<CR>", keyopts())
  keymap("n", "n", ":set hlsearch<CR>n", keyopts())
  keymap("n", "N", ":set hlsearch<CR>N", keyopts())
  keymap("n", "<C-d>", "<C-d>zz", keyopts())
  keymap("n", "<C-u>", "<C-u>zz", keyopts())
  keymap({ "n", "v" }, lk.paste.key, '"+p', keyopts({ desc = lk.paste.desc }))
  keymap({ "n" }, "[a", function()
    M.nav_arglist(vim.v.count1 * -1)
  end, keyopts({ desc = "Prev Arg File" }))
  keymap({ "n" }, "]a", function()
    M.nav_arglist(vim.v.count1)
  end, keyopts({ desc = "Next Arg File" }))
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
  makeDescMap({ "n", "v" }, lk.yank, "f", M.local_filepath_clip, "Filepath to Clipboard")
  makeDescMap({ "n", "v" }, lk.highlights, "o", M.toggle_dark_mode, "[C]hange Background Mode")
  makeDescMap("n", lk.file, "x", ":e new<CR>", "New File")
  makeDescMap("n", lk.file, "y", M.local_filepath_clip, "Filepath to clipboard")
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
  makeDescMap({ "n" }, lk.spell, "z", ':lua require("config.utils").toggle_spell_check()<CR>', "Toggle Spell Check")
  makeDescMap({ "n" }, lk.vimHelp, "p", ":lua print(", "Print [L]ua Command")
  makeDescMap({ "n" }, lk.vimHelp, "h", M.telescope_help, "Open [H]elp Reference")
  makeDescMap({ "n" }, lk.vimHelp, "s", ":! ", "Run [S]ystem Command")
  makeDescMap({ "n" }, lk.vimHelp, "fy", ":! ", "[Y]ank, [F]ile  [S]ystem Command")
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
-- Key Help UI Setup
--------------------------------

--------------------------------
-- Return Table
--------------------------------

return M

--------------------------------
