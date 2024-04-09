--------------------------------
-- ######################  --
-- #    Plugin Setup    #  --
-- ######################  --
--------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vars
----------
local opt = vim.opt
local loop = vim.loop
local system = vim.fn.system
local fn = vim.fn
local plugin_path = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_path .. "/lazy.nvim"
----------

-- Requires
----------
local plugins = require("plugins")
----------

--------------------------------
-- Plugin & Package: Installing, Loading, and Settings -- lazy.nvim & luarocks.nvim
--------------------------------

-- Package Path Upgrade
----------
-- Rocks installed through luarocks.nvim
package.path = package.path .. ";" .. plugin_path .. "/luarocks.nvim/.rocks/share/lua/5.1/?.lua"
package.path = package.path .. ";" .. plugin_path .. "/luarocks.nvim/.rocks/share/lua/5.1/?/init.lua"
-- Rocks installed through local luarocks
package.path = package.path .. ";" .. fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
----------

-- Install Package Manager(s)
----------
-- Download
if not loop.fs_stat(lazypath) then
	system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

-- Load Plugins
----------
require("lazy").setup({{ import = "plugins" } }, {})
----------

-- Install Rocks
----------
-- _rocks = { "magick", "nvim-nio", "mimetypes" }
-- require("luarocks-nvim").setup({ rocks = _rocks })
----------
