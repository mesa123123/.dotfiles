--------------------------------

-- ######################  --
-- #  Dashboard Config  #  --
-- ######################  --
--------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
local hl = vim.api.nvim_set_hl
----------

-- Requires
----------
local palette = require("config.colors").palette
local utils = require("config.utils")
----------

-- Define Highlight
----------
hl(0, "DashboardTitle", { fg = palette.dark2 })
hl(0, "DashboardMappings", { fg = palette.dark3 })
----------

-- Sections Defn
----------
local title_line = {
  type = "text",
  content = {
    "                                ",
    "                                ",
    "                                ",
    "                                ",
    "                                ",
    "                                ",
    "                                ",
    "                               ",
    "                                ",
  },
  margin = 0,
  align = "center",
  highlight = "DashboardTitle",
}

local edit_mappings = {
  type = "mapping",
  align = "center",
  content = {
    { "  Vim", "Editvim", "v" },
    {
      "  File",
      "lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ find_command = { 'fd', '--type', 'f', '--color', 'never', '--no-ignore-vcs' }}))",
      "ff",
    },
    { "  Folder", "Oil", "fe" },
    { "󰚥  Plugins", "Editplugins", "p" },
    { "  Lsp", "Editlsp", "l" },
    { "  Config", "Editconfig", "c" },
    { "  Snips", "Editsnips", "s" },
    { "  Ft", "Editft", "ft" },
    { "  Term", "EditTerm", "t" },
  },
  margin = 0,
  highlight = "DashboardMappings",
}

return {
  title_line = title_line,
  edit_mappings = edit_mappings,
  colors = {
    background = palette.light0_hard,
  },
  empty_lines_between_mappings = false,
  disable_statuslines = true,
  options = {},
  parts = { "title_line", "edit_mappings" },
}

----------
