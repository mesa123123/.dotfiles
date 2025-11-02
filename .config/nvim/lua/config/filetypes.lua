
-- ################## --
-- # Filetype Setup # --
-- ################## --
----------------------

--------------------------------
-- Module Table
--------------------------------

local M = {}

----------
--------------------------------
-- Custom File Types
--------------------------------

-- Setup Function
----------

M.setup = function()
  return vim.filetype.add({
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
      str = "javascript",
    },
  })
end
----------

--------------------------------
-- Icons Setup
--------------------------------
-- Table Declaration
----------
M.icons = {}
----------

-- Config
----------
M.icons.config = {
  default = true,
  -- CustomFileTypes
  override_by_filename = {
    ["requirements.txt"] = {
      icon = "",
      -- color = palette.bright_blue,
      cterm_color = "196",
      name = "requirements",
    },
    ["dev-requirements.txt"] = {
      icon = "",
      -- color = palette.bright_blue,
      cterm_color = "196",
      name = "requirements",
    },
  },
}
----------
-- Custom Icons
----------
M.icons.custom = {
  htmldjango = {
    icon = "",
    -- color = palette.bright_red,
    cterm_color = "196",
    name = "Htmldjango",
  },
  jinja = {
    icon = "",
    -- color = palette.bright_red,
    cterm_color = "196",
    name = "Jinja",
  },
  rst = {
    icon = "",
    -- color = palette.bright_green,
    cterm_color = "lime green",
    name = "rst",
  },
  quarto = {
    icon = "󰄫",
    -- color = palette.neutral_blue,
    cterm_color = "blue",
    name = "quarto",
  },
  qmd = {
    icon = "󰄫",
    -- color = palette.neutral_blue,
    cterm_color = "blue",
    name = "qmd",
  },
  strudel = {
    icon = "",
    -- color = palette.neutral_red,
    cterm_color = "red",
    name = "strudel",
  },
}
----------

-- Return Table
----------
return M
----------
