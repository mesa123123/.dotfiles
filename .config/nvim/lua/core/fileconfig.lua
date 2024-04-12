--------------------------
-- #################### --
-- #  Main FT Config  # --
-- #################### --
--------------------------

-------------------------------
-- Module Table
-------------------------------

local M = {}
local palette = require('core.theme').palette

-------------------------------
-- Filetype Settings
-------------------------------

-- Custom Filetypes
----------
M.setup = function()
    local ft = vim.filetype
    local gv = vim.g
	gv["do_filetype_lua"] = 1
	gv["did_load_filetypes"] = 0
	ft.add({
	  filename = {
	    ["Vagrantfile"] = "ruby",
	    ["Jenkinsfile"] = "groovy",
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
	  },
	})
	api.nvim_create_augroup("ShiftAndTabWidth", {})
    -- Filetype specific autocommands
    api.nvim_create_augroup("FileSpecs", {})
    api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    	  callback = function()
            local ft = vim.filetype
    	    local buftype = ft.match({ buf = 0 })
    	    if buftype == "gitcommit" then
    	      vim.bo.EditorConfig_disable = 1
    	    end
    	    if buftype == "markdown" then
    	      vim.wo.spell = true
    	      vim.bo.spelllang = "en_gb"
    	      vim.keymap.set("i", "<TAB>", "<C-t>", {})
    	    end
    	    if buftype == "yaml" then
    	      vim.wo.spell = true
    	      vim.bo.spelllang = "en_gb"
    	      vim.keymap.set("i", "<TAB>", "<C-t>", {})
    	    end
    	  end,
    	  group = "FileSpecs",
    })
end

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
}
----------

-- Return Table
----------
return M
----------
