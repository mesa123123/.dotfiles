--------------------------
-- ###################  --
-- # Lsp Vim Config  #  --
-- ###################  --
--------------------------

-- Package Installs
----------
-- Core Language Servers
-- TODO: Migrate these into language files
local lsp_servers_ei = {
  "lua_ls",
  "pyright",
  "bashls",
  "tsserver",
  "rust_analyzer",
  "terraformls",
  "emmet_ls",
  "jsonls",
  "yamlls",
  "cssls",
  "sqlls",
  "taplo",
  "html-lsp",
  "htmx-lsp",
  "tailwindcss-language-server",
  "solidity",
  "texlab",
  "gopls",
  "marksman",
}
-- Formatters
-- TODO: Migrate these into language files
local formatters_ei = {
  "prettier",
  "shellharden",
  "sql-formatter",
  "djlint",
  "black",
  "jq",
  "stylua",
  "yamlfmt",
  "latexindent",
  "gofumpt",
}
-- Linters
-- TODO: Migrate these into language files
local linters_ei = {
  "pylint",
  "jsonlint",
  "luacheck",
  "markdownlint",
  "yamllint",
  "shellcheck",
  "htmlhint",
  "stylelint",
  "proselint",
  "write-good",
  "solhint",
  "golangci-lint",
}
-- Debuggers
-- TODO: Migrate these into language files
local debuggers_ei = { "debugpy", "bash-debug-adapter", "codelldb", "go-debug-adapter" }
----------


-- Configure Linters
----------
-- Makdownlint
local markdownlint = lint.linters.markdownlint
markdownlint.args = {
  "--disable",
  "MD013",
  "MD012",
  "MD041",
}

-- Pylint
local pylint = lint.linters.pylint
pylint.cmd = get_venv_command("pylint")

--------------------------------
-- Setup of Language Servers
--------------------------------

-- Config Languages
----------
-- Yaml
config.yamlls.setup(lsp_opts({}))
-- Toml
config.taplo.setup(lsp_opts({}))
----------

-- Bash
----------
config.bashls.setup(lsp_opts({}))
----------

-- Lua: Language Server
----------
config.lua_ls.setup(lsp_opts({
  -- Config
  settings = {
    Lua = {
      diagnostics = { globals = { "vim", "quarto", "require", "table", "string" } },
      workspace = {
        library = api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      runtime = { verions = "LuaJIT" },
      completion = { autoRequire = false },
      telemetry = { enable = false },
    },
  },
}))
----------

-- Python: Pyright, Jedi
----------
config.pyright.setup(lsp_opts({
  on_init = function(client)
    client.config.settings.python.pythonPath = get_python_path()
  end,
}))
----------

-- Markdown
----------
config.marksman.setup(lsp_opts({
  filetypes = {
    "markdown",
    "quarto",
  },
}))
----------

-- Web
----------
-- Typescript
config.tsserver.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(lsp.protocol.make_client_capabilities()),
  on_attach = function(client)
    client.server_capabilities.document_formatting = false
  end,
})
-- Eslint
config.eslint.setup(lsp_opts({ filetypes = { "html", "javascript", "htmldjango", "jinja", "css" } }))
-- Emmet Integration
config.emmet_ls.setup(lsp_opts({ filetypes = { "css", "html", "htmldjango", "jinja" } }))
-- Html
config.html.setup(lsp_opts({ filetypes = { "html", "htmldjango", "jinja" } }))
config.htmx.setup(lsp_opts({ filetypes = { "html", "htmldjango", "jinja" } }))
-- Css
config.cssls.setup(lsp_opts({}))
-- Tailwind
config.tailwindcss.setup(lsp_opts({ filetypes = { "css", "html", "htmldjango", "jinja" } }))
----------

-- Json
----------
config.jsonls.setup(lsp_opts({
  init_options = {
    provideFormatter = true,
  },
}))
----------

-- SQL
----------
config.sqlls.setup(lsp_opts({
  root_dir = config.util.root_pattern("*.sql"),
}))
----------

-- Rust
----------
config.rust_analyzer.setup(lsp_opts({
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}))
----------

-- Solidity
----------
config.solidity.setup(lsp_opts({ root_dir = config.util.root_pattern("brownie-config.yaml", ".git") }))
----------

-- Latex
----------
config.texlab.setup(lsp_opts({}))
----------

-- Go
----------
config.gopls.setup(lsp_opts({}))
----------

-- AutoLaunch on Quarto Notebook
api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
  pattern = { "*.qmd" },
  callback = function()
    OtterStart()
  end,
})
----------

----------
-- DAP Setup
----------

require("dap")
require("lsp.dap_setup")
local dappy = require("dap-python")


-- Selection
----------
-- Python - with dap-python
dappy.setup(python_path)
dappy.test_runner = "pytest"
-- Bash
local bash_debug_adapter_bin = tool_dir .. "/packages/bash-debug-adapter/bash-debug-adapter"
local bashdb_dir = tool_dir .. "/packages/bash-debug-adapter/extension/bashdb_dir"
dap.adapters.sh = {
  type = "executable",
  command = bash_debug_adapter_bin,
}
-- C, Cpp, Rust
dap.adapters.lldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb", -- This cannot be installed through mason, requires you to do it yourself
    args = { "--port", "${port}" },
    detached = false,
  },
  name = "lldb",
}
-- Lua
dap.adapters.nlua = function(callback, opts)
  callback({
    type = "server",
    host = opts.host or "127.0.0.1",
    port = opts.port or 8086,
  })
end
----------

-- Configuration
----------
-- Python
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = fn.getcwd(),
    pythonPath = python_path,
    env = { PYTHONPATH = fn.getcwd() },
  },
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

-- Lua
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim Instance",
  },
}

-- Rust
dap.configurations.rust = {
  {
    name = "Debug Main",
    type = "lldb",
    request = "launch",
    program = function()
      local exe_path = fn.getcwd() .. "/target/debug/" .. fs.basename(fn.getcwd())
      return exe_path
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Debug Test",
    type = "lldb",
    request = "launch",
    -- TODO: use nui to sort this into a dorpdown menu you can use to pick the right target
    --  - menu is showing up but the thread doesn't wait for me to give an answer
    -- LOOKUP: Co-routines in lua
    program = function()
      local runtime = scandir_menu("Choose Runtime", "./target/debug/deps", function(item)
        return item
      end):mount()
      local exe_path = fn.getcwd() .. runtime
      return exe_path
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    cargo = {
      args = {
        "test",
        "--lib",
      },
    },
  },
}
----------

-------------------------------
-- EOF
-------------------------------
