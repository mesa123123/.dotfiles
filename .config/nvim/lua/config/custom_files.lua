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

-- Custom Icons
----------
M.icons = function()
  return {
    file = {
      ["requirements.txt"] = {
        glyph = "",
        hl = "MiniIconsOrange",
      },
      ["dev-requirements.txt"] = {
        glyph = "",
        hl = "MiniIconsOrange",
      },
    },
    lsp = {
      snippet = {
        glyph = "",
        hl = "miniiconsgreen",
      },
    },
    extension = {
      htmldjango = {
        glyph = "",
        hl = "MiniIconsOrange",
      },
      jinja = {
        glyph = "",
        hl = "MiniIconsOrange",
      },
      rst = {
        glyph = "",
        hl = "MiniIconsGreen",
      },
      quarto = {
        glyph = "󰄫",
        hl = "MiniIconsBlue",
      },
      qmd = {
        glyph = "󰄫",
        hl = "MiniIconsBlue",
      },
      strudel = {
        glyph = "",
        hl = "MiniIconsRed",
      },
      str = {
        glyph = "",
        hl = "MiniIconsRed",
      },
    },
  }
end
----------

-- Return Table
----------
return M
----------
