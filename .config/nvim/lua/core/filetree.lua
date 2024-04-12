--------------------------------
-- ######################  --
-- #  Telescope Config  #  --
-- ######################  --
--------------------------------

---------------------------------
-- Functions Handled by Telescope
---------------------------------
-- Projects
-- File Tree
-- Buffer Management
-- Buffer Diff

---------------------------------
-- Telescope Setup
---------------------------------

-- Setup
----------
local telescope_config = function(file_browser_configs)
    local tele_actions = require("telescope.actions")
    local fb_actions = require("telescope._extensions.file_browser.actions")
    return {
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
        file_browser = {
      hijack_netrw = true,
      initial_mode = "insert",
      git_status = true,
      respect_gitignore = false,
      mappings = {
        ["n"] = {
          ["<C-n>"] = tele_actions.close,
          ["<A-c>"] = fb_actions.change_cwd,
          ["h"] = fb_actions.goto_parent_dir,
          ["l"] = require("telescope.actions.set").select,
          ["c"] = fb_actions.goto_cwd,
          ["<C-a>"] = fb_actions.create,
          ["<A-h>"] = fb_actions.toggle_hidden,
        },
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
    },
        ui_select = {}
      },
    }
end

-- Extension setup (must Go last)
local extension_load = function()
    local telescope = require('telescope')
    telescope.load_extension("file_browser")
    telescope.load_extension("import")
    telescope.load_extension("ui-select")
end

--------------------------------
-- All Mappings
--------------------------------

-- Return Function
----------
local set_mappings = function()
    local nmap = require("core.utils").norm_keyset
    local lk = require('core.keymaps').lk
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
    -- File Browser
    nmap(lk.file.key .. "e", "Telescope file_browser theme=dropdown", "Toggle [F]ile [E]xplorer")
end
----------


--------------------------------
-- Return Table
--------------------------------

local M = {}

M.telescope_config = telescope_config
M.extension_load = extension_load
M.set_mappings = set_mappings

return M
----------
