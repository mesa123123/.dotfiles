local M = {}
local palette = require('core.theme').palette

M.config = {
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
  },
}

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
}

return M
