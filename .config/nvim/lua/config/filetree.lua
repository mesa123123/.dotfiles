------------------------------------
-- ##########################  --
-- #  Telescope/Oil Config  #  --
-- ##########################  --
------------------------------------

---------------------------------
-- Module Table
---------------------------------

local M = {}

---------------------------------
-- Oil Setup
---------------------------------
-- Functions Handled By Oil
----------
-- File Tree
----------

-- File Tree Options
----------
M.file_tree_config = {
  default_file_explorer = true,
  win_options = {
    signcolumn = "auto:1",
  },
  float = {
    padding = 0,
    max_width = 80,
    max_height = 30,
    border = "rounded",
    win_options = {
      winblend = 10,
      signcolumn = "auto:2",
    },
  },
  keybindings = {
    ["<C-h>"] = "actions.toggle_hidden",
  },
}
----------

---------------------------------
-- Snipe Setup
---------------------------------

-- Functions Handled by Telescope
-----------
-- Buffer Selection
-----------
M.snipe_config = {
  ui = {
    max_width = -1,
    position = "center",
  },
  navigate = { next_page = "<C-d>", previous_page = "<C-u>" },
}

---------------------------------
-- Telescope Setup
---------------------------------

-- Functions Handled by Telescope
-----------
-- Projects
-- File Tree
-- Buffer Diff

-- Setup
----------
M.telescope_config = function()
  local tele_actions = require("telescope.actions")
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
      ui_select = {},
    },
  }
end

-- Extension setup (must Go last)
M.extension_load = function()
  local telescope = require("telescope")
  telescope.load_extension("import")
  telescope.load_extension("ui-select")
end

--------------------------------
-- All Mappings
--------------------------------

M.utils = {
  find_files = function()
    require("telescope.builtin").find_files({
      theme = require("telescope.themes").get_dropdown({
        layout_strategy = "vertical",
        layout_config = {
          preview_cutoff = 10,
          height = 0.95,
          width = 0.95,
          prompt_position = "bottom",
        },
      }),
      find_command = { "fd", "--type", "f", "--color", "never", "--no-ignore-vcs" },
    })
  end,
  snipe = function()
    require("snipe").open_buffer_menu()
  end,
}

-- Return Function
----------
M.set_mappings = function()
  local nmap = require("config.utils").norm_keyset
  local descMap = require("config.utils").desc_keymap
  local lk = require("config.keymaps").lk
  nmap(lk.file.key .. "c", "Telescope commands theme=dropdown", "[C]ommands")
  nmap(lk.file.key .. "C", "Telescope colorscheme theme=dropdown", "[C]olor Schemes")
  nmap(lk.file.key .. "d", "Telescope diagnostics", "[D]iagnostics")
  descMap({ "n" }, lk.file, "f", M.utils.find_files, "[F]ind Files")

  nmap(lk.file.key .. "g", "Telescope live_grep theme=dropdown", "Live [G]rep")
  nmap(lk.file.key .. "i", "Telescope import theme=dropdown", "[I]mports")
  nmap(lk.file.key .. "j", "Telescope jumplist theme=dropdown<CR>", "[J]umplist")
  nmap(lk.file.key .. "k", "Telescope keymaps theme=dropdown", "Keymaps")
  descMap({ "n" }, lk.file_manuals, "m", "<CMD>Telescope man_pages theme=dropdown<CR>", "[M]an_pages")
  descMap({ "n" }, lk.file_manuals, "h", "<CMD>Telescope help_tags theme=dropdown<CR>", "[H]elp Tags")
  descMap({ "n" }, lk.file_history, "c", "<CMD>Telescope command_history theme=dropdown<CR>", "[C]ommand History")
  descMap({ "n" }, lk.file_history, "s", "<CMD>Telescope search_history theme=dropdown<CR>", "[S]earch History")
  nmap(lk.file.key .. "n", "Telescope notify", "[N]otifications")
  nmap(lk.file.key .. "o", "Telescope vim_options theme=dropdown<CR>", "Vim [O]ptions")
  nmap(lk.file.key .. "r", "Telescope registers theme=dropdown", "[R]egisters")
  nmap(lk.file.key .. "s", "Telescope treesitter theme=dropdown", "Treesitter [S]ymbols")
  nmap(lk.file.key .. "t", "Telescope builtin theme=dropdown", "[T]elescope Commands")
  -- Oil Keymaps
  nmap(lk.file_explorer.key .. "e", "Oil --float", "Toggle [F]ile [E]xplorer")
  nmap(lk.file_explorer.key .. "b", "Oil", "Toggle [F]ile Explorer in [B]uffer")
  nmap(lk.file_explorer.key .. "h", "lua require('oil').toggle_hidden()", "Toggle [H]idden Files")
  -- Buffer Key Maps
  descMap({ "n" }, lk.buffer_explorer, "b", "<CMD>Telescope buffers theme=dropdown<CR>", "Buffer Mgmt")
  descMap({ "n" }, lk.buffer_explorer, "f", M.utils.snipe, "Snipe Buffer")
end
----------

--------------------------------
-- Return Table
--------------------------------

return M
----------
