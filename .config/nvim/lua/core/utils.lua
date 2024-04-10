-------------------------
-- ###################  --
-- #    PDE Utils    #  --
-- ###################  --
--------------------------

--------------------------------
-- Configure Doc Commands
--------------------------------

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
local system = vim.fn.system
----------

--------------------------------
-- Function Definitions
--------------------------------

-- Mapping Opts
----------
-- Silent Mappings
M.bufopts = function(opts)
  local standardOpts = { noremap = true, silent = true, buffer = 0 }
  local opts = opts or {}
  for k, v in pairs(standardOpts) do
    opts[k] = v
  end
  return opts
end
-- Non silent Mappings
M.loudbufopts = function(opts)
  local standardOpts = { noremap = true, silent = false, buffer = 0 }
  local opts = opts or {}
  for k, v in pairs(standardOpts) do
    opts[k] = v
  end
  return opts
end
----------

-- Keyopts
----------
M.keyopts = function(opts)
  local standardOpts = { silent = true, noremap = false }
  local opts = opts or {}
  for k, v in pairs(standardOpts) do
    opts[k] = v
  end
  return opts
end
-- Loud
M.loudkeyopts = function(opts)
  local standardOpts = { silent = false, noremap = false }
  local opts = opts or {}
  for k, v in pairs(standardOpts) do
    opts[k] = v
  end
  return opts
end
----------

-- Abstraction for the vast majority of my keymappings
----------
M.norm_keyset = function(key, command, wkdesc)
  keymap.set("n", key, "<cmd>" .. command .. "<CR>", { silent = true, noremap = false, desc = wkdesc })
end
-- Loud Version
M.norm_loudkeyset = function(key, command, wkdesc)
  keymap.set("n", key, "<cmd>" .. command .. "<CR>", { silent = false, noremap = false, desc = wkdesc })
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
  if t2 ~= nil then
    for _, v in ipairs(t2) do
      table.insert(t1, v)
    end
  end
  return t1
end
----------

-- Get keys from a table
----------
M.get_table_keys = function(t1)
    if t1 == nil then
        return {}
    end
    keyarr = {}
    local n = 0
    for k, v in pairs(t1) do
     n = n+1
     keyarr[n] = k
    end 
    return keyarr
end
----------

-- Get values from a table
----------
M.get_table_values = function(t1)
    if t1 == nil then
        return {}
    end
    keyarr = {}
    local n = 0
    for k, v in pairs(t1) do
     n = n+1
     keyarr[n] = v
    end 
    return keyarr
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

-- Get Pyenv Packages if active
----------
M.get_venv_command = function(command)
	if vim.env.VIRTUAL_ENV then
		return require("lspconfig").util.path.join(vim.env.VIRTUAL_ENV, "bin", command)
	else
		return command
	end
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
  local rock_count = vim.fn.system('luarocks list | grep -c "' .. rock .. '"')
  if rock_count == 0 then
    vim.fn.system("luarocks install " .. rock)
  end
end
----------

-- A generic dependency install function
----------
M.ensure_install = function(type, packages)
  local sys_cmd = nil
  if type == "python" then
    sys_cmd = { "pip", "install" }
  end
  if sys_cmd ~= nil then
    print("Ensuring Package Installs")
    system(M.tableConcat(sys_cmd, packages))
  else
    print("Type of package not specified, doing nothing")
  end
end
----------

-- Set Shift and Tab Width
----------
M.set_shift_and_tab = function(length, patterns)
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
----------

-- Register Meta Function
----------
M.meta_load = function(func_content)
    local func, err = load("return " .. func_content)
    if func then
        local ok, out_func = pcall(func)
        if ok then
            return out_func
        else
            print("Execution Error:", out_func)
        end
    else
        print("Compilation Error:", err)
    end
end
----------

return M
