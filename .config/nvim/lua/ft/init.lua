--------------------------
-- #################### --
-- #  Main FT Config  # --
-- #################### --
--------------------------

-------------------------------
-- Module Table
-------------------------------

local M = {}

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

-------------------------------
-- Filetype Settings
-------------------------------

-- Custom Filetypes
----------
M.setup = function()
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
----------

-- Tabs and Shiftwidth
----------
	api.nvim_create_augroup("ShiftAndTabWidth", {})
-- Autocommand for shifts and tabs
	local function set_shift_and_tab(length, patterns)
	  api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	    pattern = patterns,
	    callback = function()
	      vim.bo.tabstop = length
	      vim.bo.shiftwidth = length
	      vim.bo.expandtab = true
	    end,
	    group = "ShiftAndTabWidth",
	  })
	end
-- Set them for various File extensions
	set_shift_and_tab(2, { "*.md", "*.draft", "*.lua" })
	set_shift_and_tab(4, { "*.py" })

-- Filetype specific autocommands
	api.nvim_create_augroup("FileSpecs", {})
	api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	  callback = function()
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
----------

-- Return Table
----------
return M
