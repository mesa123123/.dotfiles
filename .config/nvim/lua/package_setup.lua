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
local plugin_path = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_path .. "/lazy.nvim"
----------

--------------------------------
-- Plugin & Package: Installing, Loading, and Settings -- lazy.nvim & luarocks.nvim
--------------------------------

-- Package Path Upgrade
----------
-- Rocks installed through luarocks.nvim
package.path = package.path .. ";" .. plugin_path .. "/luarocks.nvim/.rocks/share/lua/5.1/?.lua"
package.path = package.path .. ";" .. plugin_path .. "/luarocks.nvim/.rocks/share/lua/5.1/?/init.lua"
----------

-- Install Package Manager(s)
----------
-- Download
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
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
require("lazy").setup({ { import = "plugins" } }, {})
----------
