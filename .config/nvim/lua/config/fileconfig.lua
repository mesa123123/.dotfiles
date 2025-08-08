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

-- Return Table
----------
return M
----------
