-------------------------
-- ###################  --
-- #    PDE Utils    #  --
-- ###################  --
--------------------------

--------------------------------
-- Configure Doc Commands
--------------------------------

-- Commands
----------
vim.api.nvim_create_user_command("Editutils", "e ~/.config/nvim/lua/personal_utils.lua", {}) -- Edit
vim.api.nvim_create_user_command("Srcutils", "luafile ~/.config/nvim/lua/personal_utils.lua", {}) -- Source
----------

--------------------------------
-- Module Table
--------------------------------

local M = {}

--------------------------------
-- Vim Sims and Requires
--------------------------------

-- Vim Vars
----------
local fn = vim.fn -- vim functions
local keymap = vim.keymap
local opt = vim.opt
local plugin_path = fn.stdpath("data") .. "/lazy"
----------

--------------------------------
-- Function Definitions
--------------------------------

-- Keyopts
----------
M.keyopts = function(opts)
	local standardOpts = { silent = true, noremap = true }
	for k, v in pairs(standardOpts) do
		opts[k] = v
	end
	return opts
end

M.loudkeyopts = function(opts)
	local standardOpts = { silent = false, noremap = true }
	for k, v in pairs(standardOpts) do
		opts[k] = v
	end
	return opts
end
-- Abstraction for the vast majority of my keymappings
M.norm_keyset = function(key, command, wkdesc)
	keymap.set("n", key, "<cmd>" .. command .. "<CR>", { silent = true, noremap = true, desc = wkdesc })
end
----------

-- Map(function, table)
----------
M.map = function(func, tbl)
	local newtbl = {}
	for i, v in pairs(tbl) do
		newtbl[i] = func(v)
	end
	return newtbl
end
----------

-- Filter(function, table)
----------
M.filter = function(func, tbl)
	local newtbl = {}
	for i, v in pairs(tbl) do
		if func(v) then
			newtbl[i] = v
		end
	end
	return newtbl
end
----------

-- Concat two Tables
----------
M.tableConcat = function(t1, t2)
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
	return t1
end
----------

-- Python Path
----------
M.get_python_path = function()
	-- Use Activated Environment
	if vim.env.VIRTUAL_ENV then
		return vim.env.VIRTUAL_ENV .. "/bin/" .. "python"
	end
	-- Fallback to System Python
	return fn.exepath("python3") or fn.exepath("python") or "python"
end
----------

-- Find if a file exists
----------
M.fileExists = function(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

-- Get Pyenv Packages if active
----------
M.get_venv_command = function(command)
	if vim.env.VIRTUAL_ENV then
		return require("lspconfig").util.path.join(vim.env.VIRTUAL_ENV, "bin", command)
	else
		return command
	end
end

-- Get a folders files as members of a table
----------
M.scandirMenu = function(title, dir, sub_func)
	local scan = require("plenary.scandir")
	local Menu = require("nui.menu")
	local scan_results = scan.scan_dir(dir, { hidden = false })
	local menu_lines = { Menu.separator("Sep1") }
	for _, v in pairs(scan_results) do
		local item = Menu.item(v)
		table.insert(menu_lines, item)
	end
	local dir_menu = Menu({
		position = "50%",
		border = {
			style = "single",
			text = {
				top = "[ " .. title .. " ]",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		lines = menu_lines,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_close = function()
			print("Closed Menu, operation cancelled")
		end,
		on_submit = function(item)
			sub_func(item.text)
		end,
	})
	return dir_menu
end

----------

-- On Exit for Sys Calls
----------
M.on_exit = function(obj)
	print(obj.code)
	print(obj.signal)
	print(obj.stdout)
	print(obj.stderr)
end
----------

--  A Function for installing rocks
----------
M.install_rock = function(rock)
	local rock_count = vim.fn.system("luarocks list | grep -c \"" .. rock .. "\"")
	if rock_count == 0 then
		vim.fn.system("luarocks install " .. rock)
	end
    print("installing" .. rock)
end
----------

return M
