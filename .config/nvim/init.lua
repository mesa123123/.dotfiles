------------------------------
---#####################
-- #  Main Nvim Config  #  --
-- ######################  --
--------------------------------

--------------------------------
-- TODOS
--------------------------------
-- TODO: config.utils table_concat, update it so it works with any number of tables
-- TODO: Figure out why config module is populating "completion" table
----------
-- Notifications
----------
-- TODO: Get mini.notify, vim.print, and snacks.ui to work together
-- BUG: Telescope Notifications picker no longer working
----------
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
-- TODO: Create a command for open declaration that opens in a new pane
-- TODO: YAMLLS: fix '---' document start error
-- TODO: Switch from obsidian to markdown-oxide
-- Figure out a way to make sure that you know you're in a learning directory so you can switch on oxide rather than
-- marksman
-- SUGGESTION: Use root-markers for this
-- TODO: In lsp, sort out the install function so it works asynchronously, vim.schedule will work for this
-- TODO: Python Signature help not working! Need to switch from pylsp to jedi and set  up individual bloody capabilities :(
----------
-- FORMATTING
----------
-- FEATURE: Figure out a way to run mypy on a folder and then send all of the errors to the quick-fix list
----------
-- AI
----------
-- PLUGIN: Make avante.nvim work
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
--------------------------------

--------------------------------
-- Priority Settings
--------------------------------
-- Set the config path
vim.g["config_path"] = "~/.config/nvim"
-- Set the mapleader
vim.g["mapleader"] = " "
-- TermGuiColors
vim.opt.termguicolors = true
----------

--------------------------------
-- Add Config Modules to RTPath
--------------------------------

-- Core Settings
----------
local configpath = vim.fn.stdpath("config") .. "/lua/config"
package.path = package.path .. ";" .. configpath .. "/init.lua"
----------

-- Lsp Settings
----------
local lsppath = vim.fn.stdpath("config") .. "/lua/lsp_config"
package.path = package.path .. ";" .. lsppath .. "/init.lua"
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
vim.api.nvim_create_user_command("Editpackagesetup", "e ~/.config/nvim/lua/package_setup.lua", {})
vim.api.nvim_create_user_command("Editplugins", "e ~/.config/nvim/lua/plugins/", {})
vim.api.nvim_create_user_command("Editlsp", "e ~/.config/nvim/lua/lsp_config/", {})
vim.api.nvim_create_user_command("Editconfig", "e ~/.config/nvim/lua/config/", {})
vim.api.nvim_create_user_command("Editsnips", "e ~/.config/nvim/snippets/", {})
vim.api.nvim_create_user_command("Editterm", "e ~/.wezterm.lua", {})
vim.api.nvim_create_user_command("Editqueries", function()
  edit_based_on_ft("~/.config/nvim/after/queries", "/")
end, {})
vim.api.nvim_create_user_command("Editft", function()
  edit_based_on_ft("~/.config/nvim/after/ftplugin", ".lua")
end, {})
vim.api.nvim_create_user_command("Srcvim", "luafile ~/.config/nvim/init.lua", {})
----------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Requires
----------
-- Modules
local config = require("config")
local utils = config.utils
local tC = utils.tableConcat
local python_path = utils.get_python_path()
local python_packages = utils.get_python_packages()
local dashboard_config = config.dashboard_config
local ft_settings = config.fileconfig
local fn = vim.fn
----------

-------------------------------
-- General Settings
-------------------------------

-- Set Core Options
----------
config.options.setup()
----------

-- Setup Keymaps
----------
config.keymaps.setup()
----------

-- Load Snippets
----------
config.snips.snip_maps()
----------

-- Set & Customize Colour Scheme
----------
vim.o.background = "light"
vim.cmd.colorscheme("gruvbox")
----------

-- Greeting Screen
----------
require("startup").setup(dashboard_config)
----------

--------------------------------
-- Installer and Package Management
--------------------------------

-- Variables
----------
local lsp_config = require("lsp_config").config
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
  "python-lsp-server",
  "ruff",
  "ty",
  "rust-analyzer",
  "sqlls",
  "taplo",
  "terraform-ls",
  "texlab",
  "ltex-ls",
  "tflint",
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

----------

-- Install Packages
----------
lsp_config.package_setup(tC(formatters_ei, tC(linters_ei, tC(debuggers_ei, lsp_servers_ei))))
----------

--------------------------------
-- Language Server Protocol Setup
--------------------------------

-- Capabilities Attach Function
----------
-- On Attach
local on_attach = function(client, bufnr)
  lsp_config.lsp_options()
  lsp_config.lsp_mappings()
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end
-- Capabilities
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("blink.cmp").get_lsp_capabilities({}, false)
)
----------
-- Servers
----------
lsp_config.setup("pylsp", {
  on_attach = on_attach,
  cmd = { utils.get_venv_command("pylsp") },
  filetypes = { "python", "py" },
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        jedi_signature_help = { enabled = true },
        jedi_completion = { enabled = true },
        pycodestyle = { enabled = false },
        mccabe = { enabled = false },
        pyflakes = { enabled = false },
        flake8 = { enabled = false },
        pylint = { enabled = false },
        pylsp_mypy = { enabled = true },
        pyls_isort = { enabled = false },
      },
    },
  },
  root_markers = {
    ".git",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
  },
})
lsp_config.setup("ruff", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python", "py" },
  cmd = {
    utils.get_venv_command("ruff"),
    "server",
    "--config",
    vim.fn.getcwd() .. "/pyproject.toml",
  },
  root_markers = { ".git", "pyproject.toml", "ruff.toml", ".ruff.toml" },
  init_options = {
    settings = {
      logLevel = "debug",
    },
  },
})
lsp_config.setup("ty", {
  cmd = { utils.get_venv_command("ty"), "server" },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
  root_dir = vim.fs.root(0, { ".git/", "pyproject.toml" }),
})
lsp_config.setup("lua-ls", {
  on_attach = on_attach,
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim", "quarto", "require", "table", "string" } },
      workspace = {
        checkThirdParty = false,
      },
      runtime = { verions = "LuaJIT" },
      completion = { autoRequire = false },
      telemetry = { enable = false },
    },
  },
})
lsp_config.setup("marksman", {
  on_attach = on_attach,
  cmd = { "marksman", "server" },
  root_markers = { ".marksman.toml", ".git" },
  capabilities = capabilities,
  filetypes = {
    "markdown",
    "quarto",
    "markdown.mdx",
  },
})
lsp_config.setup("yamlls", {
  on_attach = on_attach,
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_markers = { ".git" },
  capabilities = capabilities,
  settings = {
    yaml = {
      validate = true,
      completion = true,
      hover = true,
      disable = { "line-length" },
    },
    redhat = { telemetry = { enabled = false } },
  },
})
lsp_config.setup("ltex", {
  on_attach = on_attach,
  cmd = { "ltex-ls" },
  root_markers = { ".git" },
  get_language_id = function(_, filetype)
    local language_id_mapping = {
      bib = "bibtex",
      plaintex = "tex",
      rnoweb = "rsweave",
      rst = "rst",
      tex = "latex",
      text = "plaintext",
    }
    local language_id = language_id_mapping[filetype]
    if language_id then
      return language_id
    else
      return filetype
    end
  end,
  capabilities = capabilities,
  single_file_support = true,
  settings = {
    ltex = {
      language = "en-GB",
    },
  },
  filetypes = {
    "bib",
    "gitcommit",
    "org",
    "plaintex",
    "rst",
    "rnoweb",
    "tex",
    "pandoc",
    "quarto",
    "rmd",
    "context",
    "html",
    "xhtml",
    "mail",
    "text",
  },
})
lsp_config.setup("taplo", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "toml" },
  root_pattern = { ".config", ".git" },
})
lsp_config.setup("graphql", { on_attach = on_attach, capabilities = capabilities })
lsp_config.setup("jsonls", { on_attach = on_attach, capabilities = capabilities })
lsp_config.setup("bash-language-server", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "sh", "shell", "bash" },
})
----------
-- UI
----------
lsp_config.set_signs()
lsp_config.injected_setup()
----------

-- Formatter Setup
----------
require("conform").setup({
  log_level = vim.log.levels.DEBUG,
  debug = true,
  formatters_by_ft = {
    ["*"] = { "injected" },
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
    tex = { "tex-fmt" },
    yaml = { "yq" },
    toml = { "taplo" },
  },
  formatters = {
    stylua = {
      command = "stylua",
      args = {
        "--search-parent-directories",
        "--stdin-filepath",
        "$FILENAME",
        "--indent-width",
        "2",
        "--indent-type",
        "Spaces",
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
        "fix",
        "--FIX-EVEN-UNPARSABLE",
        "--config",
        os.getenv("HOME") .. "/.config/sqlfluff/.sqlfluff",
        "$FILENAME",
      },
      stdin = false,
    },
    docformatter = {
      command = utils.get_mason_package("docformatter"),
      args = { "--in-place", "$FILENAME", "--wrap-summaries", "90", "--wrap-descriptions", "90", "--force-wrap" },
      stdin = false,
    },
    markdownlint = {
      args = {
        "--disable",
        "MD013",
        "MD012",
        "MD041",
        "MD053",
        "--fix",
        "$FILENAME",
      },
    },
  },
})
lsp_config.formatter_config()
----------

-- Linter Setup
----------
local lint = require("lint")
-- Configure Linters
lint.linters_by_ft = {
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
  yaml = { "yamllint" },
}
-- Markdownlint
local markdownlint = lint.linters.markdownlint
markdownlint.args = {
  "--disable",
  "MD013",
  "MD012",
  "MD041",
}
-- MyPy
local mypy = lint.linters.mypy
mypy.cmd = utils.get_venv_command("mypy")

-- SQLFluff
local sqlfluff = lint.linters.sqlfluff
sqlfluff.cmd = utils.get_venv_command("sqlfluff")
sqlfluff.args = {
  "lint",
  "--config",
  os.getenv("HOME") .. "/.config/sqlfluff/.sqlfluff",
  "--format=json",
  "--dialect=postgres",
}

-- General Config
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

--------------------------------
-- Filetypes Setup
--------------------------------

-- Load Custom File Types
----------
ft_settings.custom_file_types()

-- Load File Type Settings
----------
for k, v in pairs(ft_settings.ft) do
  v()
end

--------------------------------
-- Database mappings
--------------------------------
-- NOTE: I don't know why the fuck this needs to be here but it doesn't work otherwise :/
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
vim.print(python_packages)
--------------------------------
---- EOF
---------------------------------
