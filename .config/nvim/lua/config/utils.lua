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
-- Creates a Key With Its Super Menu Description
M.desc_keymap = function(modes, leader_key, key, action, map_desc)
  keymap.set(
    modes,
    leader_key.key .. key,
    action,
    { silent = false, noremap = false, desc = leader_key.desc .. ": " .. map_desc }
  )
end
-- Creates one similar to norm_keyset
M.desc_keymap_cmd = function(modes, leader_key, key, action, map_desc)
  keymap.set(
    modes,
    leader_key.key .. key,
    "<cmd>" .. action .. "<CR>",
    { silent = false, noremap = false, desc = leader_key.desc .. ": " .. map_desc }
  )
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

-- Unique(List) -- Similar to Pythons set()
----------
M.unique = function(tbl)
  local unique = {}
  local inserted = {}
  for _, value in ipairs(tbl) do
    if not inserted[value] then
      unique[#unique + 1] = value
      inserted[value] = true
    end
  end
  return unique
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

-- Concat two Tables, but the key value term (You can't have two keys named the same in tables)
----------
M.tableKVConcat = function(t1, t2, p_right)
  local p = p_right and true or false
  if t2 ~= nil then
    for k, v in pairs(t2) do
      if t1[k] ~= nil then
        t1[k] = p and t1[k] or v
      else
        t1[k] = v
      end
    end
    return t1
  end
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
    n = n + 1
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
    n = n + 1
    keyarr[n] = v
  end
  return keyarr
end
----------

-- Site Pack Python Path
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

-- Create a custom python path for your python packages (used in things like dap config)
----------
M.get_python_packages = function()
  local fn = vim.fn
  local cwd = vim.fn.getcwd()
  local python_path = M.get_python_path()

  local site_packages = fn.system(python_path .. " -c \"import sysconfig; print(sysconfig.get_paths()['purelib'])\"")
  site_packages = site_packages:gsub("\n", "") -- Remove the trailing newline

  local paths = vim.env.PYTHONPATH or ""
  if not string.find(paths, site_packages, 1, true) then
    paths = site_packages .. ":" .. paths
  end
  if not string.find(paths, cwd, 1, true) then
    paths = cwd .. ":" .. paths
  end

  -- Remove trailing column if it exists
  if paths:sub(-1) == ":" then
    paths = paths:sub(1, -2)
  end

  return paths
end
----------

-- Get Pyenv Packages if active
----------
M.get_mason_package = function(command)
  local lsp_config = require("config.lsp_config")
  return lsp_config.tool_dir .. "/bin/" .. command
end
----------
-- Check if the command is in current environment path
----------
M.command_exists_in_path = function(command)
  local handle = io.popen("which " .. command .. " 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  return result ~= ""
end
----------

-- Get Pyenv Packages if active
M.get_venv_command = function(command)
  if vim.env.VIRTUAL_ENV then
    local venv_cmd = vim.env.VIRTUAL_ENV .. "/bin/" .. command
    if vim.loop.fs_stat(venv_cmd) then
      return venv_cmd
    elseif M.command_exists_in_path(command) then
      vim.print("Package: " .. command .. " not found in virtual_env bin, but found in system PATH.")
      return command
    else
      vim.print(
        "Package: "
          .. command
          .. " not installed in virtual_env or system PATH, defaulting to mason_package or reporting missing."
      )
      return M.get_mason_package(command) or command
    end
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

---- Find Project Root Markers for an LSP
----------
M.findPythonProjectRoot = function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = current_file ~= "" and vim.fn.fnamemodify(current_file, ":h") or vim.fn.getcwd()
  local previous_dir = ""

  while current_dir ~= previous_dir do
    local git_marker = current_dir .. "/.git"
    local pyproject_marker = current_dir .. "/pyproject.toml"

    if vim.fn.isdirectory(git_marker) == 1 and vim.fn.filereadable(pyproject_marker) == 1 then
      return current_dir
    end

    previous_dir = current_dir
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return nil
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

-- Toggle Spelling on and off
----------
M.toggle_spell_check = function()
  vim.opt.spell = not (vim.opt.spell:get())
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
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = patterns,
    callback = function()
      vim.bo.tabstop = length
      vim.bo.shiftwidth = length
      vim.bo.expandtab = true
    end,
    group = vim.api.nvim_create_augroup("ShiftAndTabWidth", {}),
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

-- Get a packages name - Mason
----------
M.get_package_names = function(t1)
  if t1 == nil then
    return {}
  end
  local package_names = {}
  local n = 0
  for k, v in pairs(t1) do
    n = n + 1
    if v.package_name == nil then
      package_names[n] = k
    else
      package_names[n] = v.package_name
    end
  end
  return package_names
end
----------

-- Function for uploading fallback configs in lsp, linter, formatter, debugger
M.no_cli_get_config_file = function(server_name, server_config_format)
  -- search in cwd for server config name
  local config_path = ""
  local local_config = fn.getcwd() .. "/" .. server_name .. "_config." .. server_config_format
  if M.fileExists(local_config) then
    config_path = local_config
  else
    config_path = fn.stdpath("config") .. "/lua/lsp_servers/config_file/" .. server_name .. "." .. server_config_format
  end
  return config_path
end

-- Function for determining if the buffer is oil or not
----------
M.oil_check = function(args)
  local oil = require("oil")
  if oil.get_cursor_entry() then
    return true
  end
  return false
end
----------

-- Get the directory of the current buffer
----------
M.buf_parent_dir = function()
  local Path = require("plenary.path"):new(vim.fn.expand("#:p"))
end
----------

-- Movement by Delimiter
----------

M.delim_move = function(delim_char)
  keymap.set({ "n", "v" }, "<A-l>", "f" .. delim_char, { silent = true, noremap = false, desc = "Next Delimiter" })
  keymap.set({ "n", "v" }, "<A-h>", "F" .. delim_char, { silent = true, noremap = false, desc = "Previous Delimiter" })
end
----------

-- Get debug configuration, at least for programme and argument
----------
M.debug_config = function(default_config)
  local config_path = vim.fn.getcwd() .. "/.nvim-conf" .. "/.debug_config.lua"
  local config_exists = vim.loop.fs_stat(config_path)
  local loaded_configs = config_exists and dofile(config_path) or {}
  local project_config = {}
  if next(loaded_configs) == nil then
    vim.print("Couldn't Load Debugger Config, Make sure there is one at  $PWD/.nvim-conf/.debug_config.lua")
    table.insert(project_config, default_config)
  else
    for _, v in ipairs(loaded_configs) do
      table.insert(project_config, M.tableKVConcat(vim.deepcopy(default_config[1]), v))
    end
  end
  return project_config
end
----------

-- Function to check for injected_code
----------
M.is_code_injected = function(same_ft)
  if vim.bo.filetype ~= same_ft then
    return false
  else
    return true
  end
end
----------

-- Run whatever lua code is selected
----------
M.execute_lua_selection = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(bufnr, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(bufnr, ">"))
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_row - 1, end_row, false)
  if #lines == 0 then
    print("No Lua code selected.")
    return
  end
  lines[1] = string.sub(lines[1], start_col + 1)
  lines[#lines] = string.sub(lines[#lines], 1, end_col + 1)
  local lua_code = table.concat(lines, "\n")
  local chunk, err = loadstring(lua_code)
  if not chunk then
    print("Error in Lua code:", err)
    return
  end
  local ok, result = pcall(chunk)
  if not ok then
    print("Runtime error:", result)
  else
    if result ~= nil then
      print("Output:", vim.inspect(result))
    else
      print("Executed successfully with no output.")
    end
  end
end
----------

-- Insert Virtual Text
----------
M.insertVirtualText = function()
  local bufnr = 0 -- current buffer
  local lnum = vim.fn.line(".") - 1 -- 0-based line
  local line_text = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or ""
  local line_length = #line_text -- Length of actual text
  local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, -1, { lnum, 0 }, { lnum, -1 }, { details = true })
  local insertions = {}
  for _, extmark in ipairs(extmarks) do
    local details = extmark[4] -- extmark metadata
    if details and details.virt_text then
      local column = extmark[3] -- 0-based column
      -- Only consider virtual text within actual line content
      if column < line_length then
        local text = table.concat(vim.tbl_map(function(c)
          return c[1]
        end, details.virt_text))
        table.insert(insertions, { text = text, column = column })
      end
    end
  end
  table.sort(insertions, function(a, b)
    return a.column > b.column
  end)
  for _, entry in ipairs(insertions) do
    vim.api.nvim_buf_set_text(
      bufnr,
      lnum,
      entry.column, -- Start position
      lnum,
      entry.column, -- End position (no selection)
      { entry.text } -- Text to insert
    )
  end
end
----------

--------------------------------
-- Return Table
--------------------------------

return M

----------
