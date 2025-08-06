--------------------------
-- #################### --
-- #  Main FT Config  # --
-- #################### --
--------------------------

-------------------------------
-- Module Table
-------------------------------
local M = {}
-------------------------------

-------------------------------
-- Imports
-------------------------------
local palette = require("config.theme").palette
local api = vim.api
local lk = require("config.keymaps").lk
-------------------------------

-------------------------------
-- Theme and UI
-------------------------------

-- Set Icons
----------
M.set_icons = {
  default = true,
  -- CustomFileTypes
  override_by_filename = {
    ["requirements.txt"] = {
      icon = "",
      color = palette.bright_blue,
      cterm_color = "196",
      name = "requirements",
    },
    ["dev-requirements.txt"] = {
      icon = "",
      color = palette.bright_blue,
      cterm_color = "196",
      name = "requirements",
    },
    [".sqlfluff"] = {
      icon = "",
      color = palette.bright_blue,
      cterm_color = "196",
      name = ".sqlfluff",
    },
  },
}
----------

-- Custom File Icons
----------
M.custom_icons = {
  htmldjango = {
    icon = "",
    color = palette.bright_red,
    cterm_color = "196",
    name = "Htmldjango",
  },
  jinja = {
    icon = "",
    color = palette.bright_red,
    cterm_color = "196",
    name = "Jinja",
  },
  rst = {
    icon = "",
    color = palette.bright_green,
    cterm_color = "lime green",
    name = "rst",
  },
  quarto = {
    icon = "󰄫",
    color = palette.neutral_blue,
    cterm_color = "blue",
    name = "quarto",
  },
  qmd = {
    icon = "󰄫",
    color = palette.neutral_blue,
    cterm_color = "blue",
    name = "qmd",
  },
  snippet = {
    icon = "",
    color = palette.neutral_purple,
    name = "snip",
  },
}
----------

--------------------------------
-- Custom Filetypes
--------------------------------

-- Custom
----------
M.custom_file_types = function()
  vim.filetype.add({
    filename = {
      ["Vagrantfile"] = "ruby",
      ["Jenkinsfile"] = "groovy",
      [".sqlfluff"] = "ini",
      ["output.output"] = "log",
      [".zshrc"] = "bash",
    },
    pattern = { [".*req.*.txt"] = "requirements" },
    extension = {
      hcl = "ini",
      draft = "markdown",
      env = "config",
      jinja = "jinja",
      vy = "python",
      quarto = "quarto",
      qmd = "quarto",
      snippet = "json",
    },
  })
end
----------

--------------------------------
-- File Type Settings
--------------------------------

-- Sub_Module_Table
----------
M.ft = {}
----------

-- General
----------
M.ft.general = function()
  vim.g["do_filetype_lua"] = 1
  vim.g["did_load_filetypes"] = 0
  api.nvim_create_augroup("ShiftAndTabWidth", {})
  -- Filetype specific autocommands
  api.nvim_create_augroup("FileSpecs", {})
  -- Spelling on or off?
  api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    callback = function()
      if vim.opt.diff:get() then
        require("config.vcs").mergetool_mappings()
      end
    end,
  })
end
----------

-- Markdown
----------
M.ft.markdown = function()
  api.nvim_create_autocmd("Filetype", {
    pattern = "markdown",
    callback = function()
      vim.wo.spell = true
      vim.bo.spelllang = "en_gb"
      vim.keymap.set("i", "<TAB>", "<C-t>", {})
      vim.opt_local.formatoptions:append("r") -- `<CR>` in insert mode
      vim.opt_local.formatoptions:append("o") -- `o` in normal mode
      vim.opt_local.comments = {
        "b:- [ ]", -- tasks
        "b:- [x]",
        "b:*", -- unordered list
        "b:-",
        "b:+",
      }
      require("config.utils").set_shift_and_tab(2, { "*.md" })
    end,
  })
end
----------

-- CSV
----------
M.ft.csv = function()
  api.nvim_create_autocmd("Filetype", {
    pattern = { "csv" },
    callback = function()
      -- Options
      vim.wo.wrap = false
      -- Set deliminiter movement
      require("config.utils").delim_move(",")
    end,
  })
  api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.csv",
    callback = function()
      vim.cmd("RainbowShrink")
    end,
    desc = "Run RainbowShrink on Save",
  })
  api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.csv",
    callback = function()
      vim.cmd("RainbowAlign")
    end,
    desc = "Run RainbowAlign on Open",
  })
end
----------

-- Dbout
----------
M.ft.dbout = function()
  api.nvim_create_autocmd("Filetype", {
    pattern = { "dbout" },
    callback = function()
      -- Set deliminiter movement
      require("config.utils").delim_move("|")
    end,
  })
end
----------

-- Python
----------
M.ft.python = function()
  api.nvim_create_autocmd("Filetype", {
    pattern = { "python" },
    callback = function()
      require("config.utils").set_shift_and_tab(4, { "*.py" })
      vim.opt_local.colorcolumn = "90"
    end,
  })
end
----------

-- SQL
----------
M.ft.sql = function()
  api.nvim_create_autocmd("Filetype", {
    pattern = { "sql" },
    callback = function()
      require("config.utils").set_shift_and_tab(4, { "*.sql" })
      vim.opt_local.colorcolumn = "90"
    end,
  })
  vim.api.nvim_create_augroup("FixSQLFormatting", { clear = true })
  local makeDescMap = require("config.utils").desc_keymap
  makeDescMap({ "v" }, lk.uniqueft, "r", function()
    vim.cmd('normal! "vy')
    local old_selection = vim.fn.getreg("v")
    if old_selection == "" then
      vim.notify("No text selected! Please select 'column_name::datatype' in visual mode.", vim.log.levels.ERROR)
      return
    end
    local old_col, datatype = old_selection:match("^(.-)::(.-)$")
    if not old_col or not datatype then
      vim.notify("Invalid selection! Please select 'column_name::datatype'.", vim.log.levels.ERROR)
      return
    end
    local new_col = vim.fn.input("Enter new column name: ")
    if new_col == "" then
      return
    end -- Exit if no input
    local old_selection_escaped = vim.pesc(old_selection)
    vim.cmd(string.format("%%s/\\<%s\\>/%s::%s AS %s/g", old_selection_escaped, new_col, datatype, old_col))
    vim.notify(
      string.format("Replaced '%s' with '%s::%s AS %s'", old_selection, new_col, datatype, old_col),
      vim.log.levels.INFO
    )
  end, "[R]ename Typed SQL Column ")
end
----------

-- Yaml
----------
M.ft.yaml = function()
  api.nvim_create_autocmd("Filetype", {
    pattern = { "yaml" },
    callback = function()
      require("config.utils").set_shift_and_tab(2, { "*.yaml", "*.yml" })
      vim.wo.spell = true
      vim.bo.spelllang = "en_gb"
      vim.keymap.set("i", "<TAB>", "<C-t>", {})
      vim.opt_local.colorcolumn = "90"
    end,
  })
end
----------

-- Lua
----------
M.ft.lua = function()
  api.nvim_create_autocmd("Filetype", {
    pattern = { "lua" },
    callback = function()
      require("config.utils").set_shift_and_tab(2, { "*.py" })
    end,
  })
end
----------

-- Git
----------
M.ft.git = function()
  api.nvim_create_autocmd("FileType", {
    pattern = "git",
    callback = function()
      local descMap = require("config.utils").desc_keymap
      local lk = require("config.keymaps").lk
      if buftype == "gitcommit" then
        vim.bo.EditorConfig_disable = 1
      end
    end,
  })
end
----------

-- Return Table
----------
return M
----------
