-------------------------------
-- ###################### --
-- #  Main Nvim Config  # --
-- ###################### --
--------------------------------

--------------------------------
-- TODOS
--------------------------------
-- TODO: config.utils table_concat, update it so it works with any number of tables
-- TODO: Figure out why config module is populating "completion" table
--      local has_completion,completion = pcall(require, 'completion')
----------
-- Notifications
----------
-- TODO: Get mini.notify, vim.print, and snacks.ui to work together
----------
-- Snippets
----------
-- TODO: Figure out a way to only add a snippet if the file is titled a certain way. e.g. .debug_config.lua
-- BUG: DBT snippets keep trying to load in average sql files
-- FIX: I think I need a way to tell if I"m in a dbt project and then load extra snips configd on that in the sql snip
-- file?
----------
-- Filetype Stuff
----------
-- TODO: Set up filetype settings for best practices - as in not all the lsp setup stuff in this file rather in their
-- own filetype files
-- TODO: Create a way to automatically make line length set for certain filetypes
----------
-- Formatter
----------
-- TODO: SQL figure out a way to get the formatter working with query files in dadbodui
----------
-- Terminal
----------
-- TODO: Get rid of toggle term and just use the api from DVries video
----------
-- DAP
-- BUG: Can't have more than one config in a debug_conf file.
-- TODO: Create a command to edit/reload project dap configurations in place
-- TODO: Create a command like GetDapConfig that shows current dap configs
-- TODO: Create a way so that the .debug_config.lua file can read multiple languages
-- TODO: Update the debug config to allow for selection for each config and full configs in the project dir
-- TODO: Create a way for DAP to run multiprocesses by default
----------
-- LSP
----------
-- TODO: YAMLLS: fix '---' document start error
-- TODO: Switch from obsidian to markdown-oxide
-- Figure out a way to make sure that you know you're in a learning directory so you can switch on oxide rather than
-- marksman
-- SUGGESTION: Use root-markers for this
----------
-- FORMATTING
----------
-- FEATURE: Figure out a way to run mypy on a folder and then send all of the errors to the quick-fix list
----------
-- DADBOD
----------
-- BUG: The dadbodui opens in a new tab but once I try to reopen it I want it to go back to that tab
-- BUG: Keymappings don't stick unless I put them at the bottom of this file
----------
-- CODE FOLDING
----------
-- TODO: Folded titles displaying as '0'
-- SUGGESTION: (Steal logic from Markdown.nvim should help with this problem)
----------
-- MARKDOWN
----------
-- TODO: Figure out how to get a custom comment on `gcc`
-- SUGGESTION: in config folder after -> ftplugin -> create a markdown.lua file and use a similar makeup to the sql
-- sibling file
----------
-- Treesitter
----------
-- BUG: Key map in config Not using config keymapping files
-- BUG: Python Docstrings not conforming to injection code, start with minial config and work from there.
-- TODO: Figure out how to get only the examples in a python module docstring to highlight as python code
-- TODO: On buffer picker, figure out how to delete an unwritten buffer on ALT | SHIFT | d
----------
-- Oil.nvim
----------
-- TODO: Key map <leader>feh to open in current directory with hidden files if oil isn't open
----------
-- Feature Ideas
----------
-- FEATURE: Create a minimal config for dbugging
-- FEATURE: Prime talked about only updating every year, perhaps I have a plugin that allows me to manage my config,
-- basically a way of taking this comment list and then upvote certain things and then schedule days where I can
-- update the config, and gets the most pressing issues (i.e. this is currently annoying me, it gets an upvote for the
-- next config day).
-- PLUGIN: Snacks.nvim (especially, buf-delete, indent-lines, dashboard)
-- PLUGIN: See if mini.hicolours can replace todo.comments
--------------------------------

--------------------------------
-- Priority Settings
--------------------------------
vim.g["config_path"] = "~/.config/nvim"
vim.g["mapleader"] = " "
vim.opt.termguicolors = true
----------

--------------------------------
-- Add Config Modules to RTPath
--------------------------------
-- Core Settings
----------
local configpath = vim.fn.stdpath("config") .. "/lua/config"
package.path = package.path .. ";" .. configpath
----------

-- Snippets
----------
local snippath = vim.fn.stdpath("config") .. "/snippets"
package.path = package.path .. ";" .. snippath
----------

-- Plugins Path
----------
local plugin_path = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_path .. "/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
require("package_setup")
----------

--------------------------------
-- Configure Editing Commands
--------------------------------

-- Utils for Editing
----------
local function edit_based_on_ft(folder, suffix)
  local ft = vim.bo.filetype -- Get current buffer's filetype
  if ft == "" then
    vim.notify("No filetype detected!", vim.log.levels.WARN)
    return
  end
  local path = table.concat({ folder, ft }, "/")
  vim.cmd("edit " .. path .. suffix)
end

----------

-- Commands for Editing
----------
vim.api.nvim_create_user_command("Editvim", "e ~/.config/nvim/init.lua", {})
vim.api.nvim_create_user_command("Editworkspace", "e " .. vim.fn.getcwd() .. "/.nvim.lua", {})
vim.api.nvim_create_user_command("Editpackagesetup", "e ~/.config/nvim/lua/package_setup.lua", {})
vim.api.nvim_create_user_command("Editplugins", "e ~/.config/nvim/lua/plugins/", {})
vim.api.nvim_create_user_command("Editlsp", "e ~/.config/nvim/lsp/", {})
vim.api.nvim_create_user_command("Editconfig", "e ~/.config/nvim/lua/config/", {})
vim.api.nvim_create_user_command("Editsnips", "e ~/.config/nvim/snippets/", {})
vim.api.nvim_create_user_command("Editterm", "e ~/.wezterm.lua", {})
vim.api.nvim_create_user_command("Editqueries", function()
  edit_based_on_ft("~/.config/nvim/after/queries", "/")
end, {})
vim.api.nvim_create_user_command("Editft", function()
  edit_based_on_ft("~/.config/nvim/after/ftplugin", ".lua")
end, {})
vim.api.nvim_create_user_command("Sov", "so " .. vim.g["config_path"] .. "/init.lua", {})
----------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Requires
----------
local config = require("config")
local utils = config.utils
local tC = utils.tableConcat
local python_path = utils.get_python_path()
local python_packages = utils.get_python_packages()
local fn = vim.fn
----------

-------------------------------
-- General Settings
-------------------------------

-- Core Config Setups
----------
config.options.setup()
config.keymaps.setup()
config.snips.snip_maps()
config.commands.setup()
----------

-- Set & Customize Colour Scheme
----------
vim.o.background = "light"
vim.cmd.colorscheme("gruvbox")
----------

-- Workspace Settings
----------
local workspace = config.workspace.load()
-- Load Config Function
local get_workspace_setting = function(key, default_value)
  return (workspace and workspace[key]) or default_value
end
----------

-- Dashboard
----------
require("mini.starter").setup({
  items = {
    { name = "VimSettings ", action = "Editvim", section = "Options" },
    { name = "ProjectSettings ", action = "Editworkspace", section = "Options" },
    { name = "Folder ", action = "Oil", section = "Options" },
    { name = "Plugins ", action = "Editplugins", "p", section = "Options" },
    { name = "Config ", action = "Editconfig", section = "Options" },
    { name = "Snips ", action = "Editsnips", section = "Options" },
    { name = "Ft ", action = "Editft", section = "Options" },
  },
})
-- ----------

-- Globals
----------
vim.g["do_filetype_lua"] = 1
vim.g["did_load_filetypes"] = 0
----------

-- Load Custom File Types
----------
vim.filetype.add({
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
  },
})
----------

--------------------------------
-- Autocommands
--------------------------------

-- Only activate merge tool on a merge diff
----------
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    if vim.opt.diff:get() then
      require("config.vcs").mergetool_mappings()
    end
  end,
})
----------

--------------------------------
-- Installer and Package Management
--------------------------------

-- Variables
----------
local lsp_config = require("config").lsp_config
vim.lsp.set_log_level("debug")
----------

-- Packages for Install
----------
-- Core Language Servers
local lsp_servers_ei = {
  "bash-language-server",
  "emmet-ls",
  "json-lsp",
  "lua-language-server",
  "marksman",
  "pyright",
  "ruff",
  "ty",
  "rust-analyzer",
  "sqlls",
  "taplo",
  "terraform-ls",
  "texlab",
  "ltex-ls",
  "tflint",
  "typescript-language-server",
  "yaml-language-server",
  "graphql-language-service-cli",
}
-- Formatters
local formatters_ei = {
  "docformatter",
  "jq",
  "markdownlint",
  "prettier",
  "ruff",
  "beautysh",
  "stylua",
  "tex-fmt",
  "yq",
}
-- Linters
local linters_ei = {
  "djlint",
  "eslint_d",
  "htmlhint",
  "jsonlint",
  "luacheck",
  "markdownlint",
  "mypy",
  "proselint",
  "ruff",
  "rstcheck",
  "shellcheck",
  "shellharden",
  "sqlfluff",
  "stylelint",
  "tflint",
  "write-good",
  "yamllint",
}
-- Debuggers
local debuggers_ei = {
  "bash-debug-adapter",
  "codelldb",
  "debugpy",
}

local default_ensure_installed = tC(formatters_ei, tC(linters_ei, tC(debuggers_ei, lsp_servers_ei)))
----------

-- Install Packages
----------
local ensure_installed = get_workspace_setting("ensure_installed", default_ensure_installed)
lsp_config.package_setup(ensure_installed)
----------

--------------------------------
-- Language Server Protocol Setup
--------------------------------

-- Diagnostics
----------
lsp_config.diagnostics()
----------

-- Servers
----------
for _, v in ipairs(ensure_installed) do
  if v == "lua-language-server" then
    lsp_config.setup("lua_ls")
  elseif v == "python-lsp-server" then
    lsp_config.setup("pylsp")
  elseif v == "typescript-language-server" then
    lsp_config.setup("ts_ls")
  else
    lsp_config.setup(v)
  end
end
----------

--------------------------------
-- Formatters & Linter Setup
--------------------------------

-- Formatter Setup
----------
local default_formatters_by_ft = {
  bash = { "beautysh" },
  graphql = { "prettier" },
  jinja = { "djlint" },
  json = { "jq" },
  lua = { "stylua" },
  markdown = { "markdownlint", "injected" },
  python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
  shell = { "beautysh" },
  sh = { "beautysh" },
  sql = { "sqlfluff" },
  rst = { "rstfmt" },
  rust = { "rustfmt" },
  terraform = { "terraform_fmt" },
  typescript = { "prettier" },
  tex = { "tex-fmt" },
  yaml = { "yq" },
  toml = { "taplo" },
}

local default_formatter_config = {
  stylua = {
    command = "stylua",
    args = {
      "--search-parent-directories",
      "--stdin-filepath",
      "$filename",
      "--indent-width",
      "2",
      "--indent-type",
      "spaces",
      "--column-width",
      "120",
      "-",
    },
  },
  sqlfluff = {
    command = function()
      return utils.get_venv_command("sqlfluff") or "sqlfluff"
    end,
    args = {
      "format",
      "--config",
      vim.env.HOME .. "/.config/sqlfluff/.sqlfluff",
      "-",
    },
  },
  docformatter = {
    command = utils.get_mason_package("docformatter"),
    args = { "--in-place", "$filename", "--wrap-summaries", "90", "--wrap-descriptions", "90", "--force-wrap" },
    stdin = false,
  },
  markdownlint = {
    args = {
      "--disable",
      "md013",
      "md012",
      "md041",
      "md053",
      "--fix",
      "$filename",
    },
  },
}

local formatters_by_ft = get_workspace_setting("formatters_by_ft", default_formatters_by_ft)
local formatter_config = get_workspace_setting("formatters", default_formatter_config)

require("conform").setup({
  log_level = vim.log.levels.DEBUG,
  debug = true,
  formatters_by_ft = formatters_by_ft,
  formatters = formatter_config,
})
lsp_config.formatter_config()
----------

-- Linter Setup
----------

local default_linters_by_ft = {
  ["*"] = { "compiler" },
  bash = { "shellcheck" },
  css = { "stylelint", "prettier" },
  html = { "htmlhint" },
  jinja = { "djlint" },
  json = { "jsonlint" },
  lua = { "luacheck" },
  markdown = { "markdownlint", "proselint", "write_good" },
  python = { "ruff" },
  quarto = { "markdownlint", "proselint", "write_good" },
  rst = { "rstcheck" },
  sql = { "sqlfluff" },
  terraform = { "tflint" },
  typescript = { "eslint_d" },
  yaml = { "yamllint" },
}
local linters_by_ft = get_workspace_setting("linters_by_ft", default_linters_by_ft)

local lint = require("lint")
-- Configure Linters
lint.linters_by_ft = linters_by_ft
-- Python Linters
for _, linter_name in ipairs(linters_by_ft.python) do
  local original_linter = lint.linters[linter_name]
  if original_linter then
    lint.linters[linter_name] = vim.tbl_deep_extend("force", {}, original_linter, {
      cmd = utils.get_venv_command(linter_name),
    })
  end
end
-- Markdownlint
local markdownlint = lint.linters.markdownlint
markdownlint.args = {
  "--disable",
  "MD013",
  "MD012",
  "MD041",
}
-- SQLFluff
local sqlfluff = lint.linters.sqlfluff
sqlfluff.cmd = utils.get_venv_command("sqlfluff")
sqlfluff.args = {
  "lint",
  "--config",
  os.getenv("HOME") .. "/.config/sqlfluff/.sqlfluff",
  "--format=json",
}

-- Luacheck
local luacheck = lint.linters.luacheck
luacheck.cmd = "luacheck"
luacheck.stdin = true
luacheck.args = {
  "--globals",
  "vim",
  "lvim",
  "reload",
  "--",
}
luacheck.stream = "stdout"
luacheck.ignore_exitcode = true
luacheck.parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
  source = "luacheck",
})

lsp_config.linter_config()
----------

--------------------------------
-- Dap Setup
--------------------------------

-- Vars
----------
local dap = require("dap")
local bash_debug_adapter_bin = lsp_config.tool_dir .. "/packages/bash-debug-adapter/bash-debug-adapter"
local bashdb_dir = lsp_config.tool_dir .. "/packages/bash-debug-adapter/extension/bashdb_dir"
----------

-- Configuration
----------
-- Python
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Python: Current file",
    program = "${file}",
    cwd = fn.getcwd(),
    pythonPath = python_path,
    env = { PYTHONPATH = python_packages },
    justMyCode = false,
  },
  {
    name = "Pytest: Current File",
    type = "python",
    request = "launch",
    module = "pytest",
    args = { "--pdb", "${file}" },
    cwd = fn.getcwd(),
    pythonPath = python_path,
    env = { PYTHONPATH = python_packages },
    console = "integratedTerminal",
    justMyCode = false,
  },
}
dap.adapters.python = {
  type = "executable",
  command = python_path, -- e.g., "/usr/bin/python3"
  args = { "-m", "debugpy.adapter" },
}
-- Shell/Bash
dap.configurations.sh = {
  {
    name = "Launch Bash debugger",
    type = "sh",
    request = "launch",
    program = "${file}",
    cwd = "${fileDirname}",
    pathBashdb = bashdb_dir .. "/bashdb",
    pathBashdbLib = bashdb_dir,
    pathBash = "bash",
    pathCat = "cat",
    pathMkfifo = "mkfifo",
    pathPkill = "pkill",
    env = {},
    args = {},
  },
}
dap.adapters.sh = {
  type = "executable",
  command = bash_debug_adapter_bin,
}
-- Lua
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end
----------

-- Toggle Database
----------
local lk = require("config.keymaps").lk
local descMap = require("config.utils").desc_keymap

-- KeyMaps
----------
descMap({ "n" }, lk.database, "u", ":tabnew<CR>:DBUIToggle<CR>:set nu<CR>:set relativenumber<CR>", "Toggle DB UI")
descMap({ "n" }, lk.database, "f", ":DBUIFindBuffer<CR>", "Find DB Buffer")
descMap({ "n" }, lk.database, "r", ":DBUIRenameBuffer<CR>", "Rename DB Buffer")
descMap({ "n" }, lk.database, "l", ":DBUILastQueryInfo<CR>", "Run Last Query")
vim.keymap.set({ "n", "v" }, lk.database.key .. "x", "<Plug>(DBUI_ExecuteQuery)", { desc = "Run Query" })
----------
vim.g.db_ui_use_nerd_fonts = 1
----------

--------------------------------
---- EOF
---------------------------------
