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
-- Add Config Modules to RTPath
--------------------------------

-- Core Settings
----------
local corepath = vim.fn.stdpath("config") .. "/lua/core"
package.path = package.path .. ';' .. corepath .. '/init.lua'
----------

-- FT Settings
----------
local ftpath = vim.fn.stdpath("config") .. "/lua/ft"
package.path = package.path .. ';' .. ftpath .. '/?.lua'
----------

-- Plugins Path
----------
local plugin_path = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_path .. "/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
----------

--------------------------------
-- Configure Doc Commands
--------------------------------

-- Commands for Editing Docs
----------
vim.api.nvim_create_user_command("Editvim", "e ~/.config/nvim/init.lua", {})
vim.api.nvim_create_user_command("Editpackagesetup", "e ~/.config/nvim/lua/package_setup.lua", {})
vim.api.nvim_create_user_command("Editplugins", "e ~/.config/nvim/lua/plugins.lua", {})
vim.api.nvim_create_user_command("Editutils", "e ~/.config/nvim/lua/core/utils.lua", {})
vim.api.nvim_create_user_command("Editleadermaps", "e ~/.config/nvim/lua/leader_mappings.lua", {})
vim.api.nvim_create_user_command("Editlsp", "e ~/.config/nvim/lua/lsp/init.lua", {})
vim.api.nvim_create_user_command("Editcolors", "e ~/.config/nvim/lua/colors.lua", {})
vim.api.nvim_create_user_command("Edittheme", "e ~/.config/nvim/lua/theme.lua", {})
vim.api.nvim_create_user_command("Editnotebooks", "e ~/.config/nvim/lua/notebooks.lua", {})
vim.api.nvim_create_user_command("Editoptions", "e ~/.config/nvim/lua/core/options/lua", {})
vim.api.nvim_create_user_command("Editcmp", "e ~/.config/nvim/lua/lsp/cmp_setup.lua", {})
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
local core = require("core")
local ufuncs = core.utils
local theme = core.theme
local palette = theme.palette
local options = core.options
km = core.keymaps
lk = km.lk
-- Scripts
require("package_setup")
-- require("lsp")
----------

-- Extra Vars
----------
local nmap = ufuncs.norm_keyset
local keyopts = ufuncs.keyopts
local nlmap = ufuncs.norm_loudkeyset
local get_python_path = ufuncs.get_python_path
----------

-------------------------------
-- General Settings
-------------------------------

-- Set Core Options
----------
options.setup()
----------

-- Set & Customize Colour Scheme
----------
cmd("colorscheme theme")
----------

-- Setup Keymaps
----------
km.setup()
----------

-- Zen Mode
----------
nmap(lk.zen.key, 'lua require("zen-mode").toggle({ window = { width = .85 }})', "Zen Mode Toggle")
----------


----------------------------------
-- Editor Mappings
----------------------------------
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
nmap(lk.file.key .. "e", "Telescope file_browser theme=dropdown", "Toggle [F]ile [E]xplorer")
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

nmap(lk.todo.key, "TodoTelescope", "List Todos")
----------

---------------------------------
-- Buffer Management: <leader>f  - Telescope Core
---------------------------------

-- Mappings
----------
nmap(lk.file.key .. "b", "Telescope buffers theme=dropdown", "Show Buffers")
nmap("<C-b>s", "Telescope buffers theme=dropdown", "Show Buffers")
nmap(lk.file.key .. "c", "Telescope colorscheme theme=dropdown", "Themes")
nmap(lk.file.key  .. "d", "Telescope diagnostics", "Diagnostics")
nmap(lk.file.key .. "f", "Telescope find_files theme=dropdown", "Find Files")
nmap(lk.file.key .. "g", "Telescope live_grep theme=dropdown", "Live Grep")
nmap(lk.file.key .. "H", "Telescope help_tags theme=dropdown", "Help Tags")
nmap(lk.file.key .. "i", "Telescope import theme=dropdown", "Imports")
nmap(lk.file.key .. "j", "Telescope jumplist theme=dropdown<CR>", "Jumplist")
nmap(lk.file.key .. "k", "Telescope keymaps theme=dropdown", "Keymaps")
nmap(lk.file.key .. "m", "Telescope man_pages theme=dropdown", "Man Pages")
nmap(lk.file.key .. "n", "Telescope notify", "Notifications")
nmap(lk.file.key .. "o", "Telescope vim_options theme=dropdown<CR>", "Vim Options")
nmap(lk.file.key .. "r", "Telescope registers theme=dropdown", "Registers")
nmap(lk.file.key .. "s", "Telescope treesitter theme=dropdown", "Treesitter Insights")
nmap(lk.file.key .. "t", "Telescope builtin theme=dropdown", "Telescope Commands")
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
-- Latex Functionality: <leader>l - Vimtex
---------------------------------
-- TODO: Put into latex settings file

-- Setup (Currently not supported in Lua)
----------
api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.tex" },
  callback = function()
    vim.g["vimtext_view_method"] = "zathura"
  end,
})
----------

---------------------------------
-- Code Align
---------------------------------

-- Mappings
----------
-- Start interactive EasyAlign in visual mode (e.g. vipga)
keymap.set("x", lk.codeAction_alignment.key, "<Plug>(EasyAlign)<CR>", { desc = "Easy Align" })
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
keymap.set("n", lk.codeAction_alignment.key, "<Plug>(EasyAlign)<CR>", { desc = "Easy Align" })
----------

---------------------------------"
-- Database Commands - DadBod
---------------------------------"
-- TODO: Put this config into the sql settings file


-- Options
---------
gv["db_ui_save_location"] = "~/.config/db_ui"
gv["dd_ui_use_nerd_fonts"] = 1
----------

-- Mappings
---------
nmap(lk.database.key .. "u", "DBUIToggle<CR>", "Toggle DB UI")
nmap(lk.database.key .. "f", "DBUIFindBuffer<CR>", "Find DB Buffer")
nmap(lk.database.key .. "r", "DBUIRenameBuffer<CR>", "Rename DB Buffer")
nmap(lk.database.key .. "l", "DBUILastQueryInfo<CR>", "Run Last Query")
---------

---------------------------------"
-- Code Execution - compiler.nvim, overseer, vimtext
---------------------------------"

-- Mappings
----------
api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    leader_key = require('core.keymaps').lk.exec.key
    if vim.bo.filetype == "tex" then
      vim.keymap.set(
        "n",
        leader_key .. "x",
        "<cmd>VimtexCompile<CR>",
        { silent = true, noremap = false, desc = "Compile Doc" }
      )
    else
      vim.keymap.set(
        "n",
        leader_key .. "x",
        "<cmd>CompilerOpen<CR>",
        { silent = true, noremap = false, desc = "Run Code" }
      )
    end
  end,
})
nmap(lk.exec.key .. "q", "CompilerStop", "Stop Code Runner")
nmap(lk.exec.key .. "i", "CompilerToggleResults", "Show Code Run")
nmap(lk.exec.key .. "r", "CompilerStop<cr>" .. "<cmd>CompilerRedo", "Re-Run Code")
----------

---------------------------------"
-- Http Execution - rest.nvim
---------------------------------"

nmap(lk.exec_http.key .. "x", "RestNvim", "Run Http Under Cursor")
nmap(lk.exec_http.key .. "p", "RestNvimPreview", "Preview Curl Command From Http Under Cursor")
nmap(lk.exec_http.key .. "x", "RestNvim", "Re-Run Last Http Command")


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
nmap(lk.exec_test_coverage.key .. "r", "Coverage", "Run Coverage Report")
nmap(lk.exec_test_coverage.key .. "s", "CoverageSummary", "Show Coverage Report")
nmap(lk.exec_test_coverage.key .. "t", "CoverageToggle", "Toggle Coverage Signs")
----------

----------------------------------
---- Workspace Specific Configs
----------------------------------
--
---- Allow WorkSpace Specific Init
---- if filereadable("./ws_init.lua")
----     luafile ./ws_init.lua
---- endif
--
----------------------------------
---- EOF
---------------------------------
