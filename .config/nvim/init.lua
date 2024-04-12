--------------------------------
-- ######################  --
-- #  Main Nvim Config  #  --
-- ######################  --
--------------------------------

--------------------------------
-- Priority Settings
--------------------------------
-- Set the config path
vim.g["config_path"] = "~/.config/nvim"
-- Set the mapleader
vim.g["mapleader"] = "\\"
-- TermGuiColors
vim.opt.termguicolors = true

--------------------------------
-- Add Config Modules to RTPath
--------------------------------

-- Core Settings
----------
local corepath = vim.fn.stdpath("config") .. "/lua/core"
package.path = package.path .. ";" .. corepath .. "/init.lua"
----------

-- FT Settings
----------
local ftpath = vim.fn.stdpath("config") .. "/lua/ft"
package.path = package.path .. ";" .. ftpath .. "/?.lua"
----------

-- Plugins Path
----------
local plugin_path = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_path .. "/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
----------

--------------------------------
-- Configure Doc Commands
--------------------------------

-- Commands for Editing Docs
----------
vim.api.nvim_create_user_command("Editvim", "e ~/.config/nvim/init.lua", {})
vim.api.nvim_create_user_command("Editpackagesetup", "e ~/.config/nvim/lua/package_setup.lua", {})
vim.api.nvim_create_user_command("Editplugins", "e ~/.config/nvim/lua/plugins/", {})
vim.api.nvim_create_user_command("Editlsp", "e ~/.config/nvim/lua/lsp/", {})
vim.api.nvim_create_user_command("Editcore", "e ~/.config/nvim/lua/core/", {})
vim.api.nvim_create_user_command("Editft", "e ~/.config/nvim/lua/ft/", {})
vim.api.nvim_create_user_command("Srcvim", "luafile ~/.config/nvim/init.lua", {})
----------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Requires
----------
-- Modules
local core = require("core")
local dashboard_config = core.dashboard_config
----------

-------------------------------
-- General Settings
-------------------------------

-- Set & Customize Colour Scheme
----------
vim.cmd("colorscheme theme")
----------

-- Set Core Options
----------
core.options.setup()
----------

-- Setup Keymaps
----------
core.keymaps.setup()
----------

-- Load Plugins
----------
require("package_setup")
----------

-- Greeting Screen
----------
require("startup").setup(dashboard_config)
----------

-------------------------------
-- Filetype Settings
-------------------------------

-- All Filetypes
----------
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		local cmp_setup = require("lsp").cmp
		for k, v in pairs(cmp_setup.source_ft) do
			cmp_setup.source_ft[k]()
		end
		local nullSources = {}
		nullSources[#nullSources + 1] = require("null-ls").builtins.completion.spell.with({
			autostart = true,
			filetypes = { "txt", "markdown", "md", "mdx", "tex", "yaml" },
		})
		nullSources[#nullSources + 1] = require("null-ls").builtins.hover.dictionary.with({
			autostart = true,
			filetypes = { "txt", "markdown", "md", "mdx" },
		})
		-- Package Load
		require("null-ls").setup({
			capabilities = cmp_setup.capabilities(),
			debug = true,
			sources = { sources = nullSources },
		})
	end,
})
----------

-- Load Ft Settings
----------

for k, v in pairs(require("ft")) do
    local ext = v.ext or k
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
		pattern = { "*." .. ext },
		callback = function()
			require("lsp.lsp_core").setup(v, k)
		end,
	})
end
----------

----------------------------------
---- EOF
---------------------------------
