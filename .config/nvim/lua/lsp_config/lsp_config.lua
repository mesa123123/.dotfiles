--------------------
-- ############## --
-- # Lsp Config # --
-- ############## --
--------------------

-- Module table
----------
local M = {}
----------

--------------------------------
-- Servers Location
--------------------------------
M.tool_dir = os.getenv("HOME") .. "/.local/share/nvim/lsp_servers/"
----------

--------------------------------
-- Package Install Functions
--------------------------------

M.package_setup = function(packages)
  --- TODO: Sort out async problems with this function
  -- Vars
  ----------
  local tool_manager = require("mason")
  local registry = require("mason-registry")
  ----------
  -- Setup Tool Manager
  ----------
  tool_manager.setup({
    install_root_dir = M.tool_dir,
  })
  ----------
  -- Install Packages
  ----------
  for _, package in ipairs(packages) do
    local pkg = registry.get_package(package)
    if not pkg:is_installed() then
      -- SUGGESTION: Use vim.schedule to run this in some kind of queue
      pkg:install()
    end
  end
  ----------
  -- Update Packages
  ----------
  registry.update()
  vim.api.nvim_command("MasonUpdate")
  ----------
end

--------------------------------
-- LSP Setup
--------------------------------

-- Setup Func
----------
M.setup = function(name, settings)
  settings = settings or {}
  vim.lsp.config(name, settings)
  if name ~= "*" then
    vim.lsp.enable(name)
  end
end

--------------------------------
-- Lsp Config
--------------------------------

-- Options
----------
M.lsp_options = function()
  ----------
  -- Options
  ----------
  vim.b["max_line_length"] = 0
  vim.lsp.inlay_hint.enable(true)
  vim.lsp.with(vim.lsp.handlers.hover, { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } }
  )
  ----------
  -- Functions
  ----------
  function ShortenLine()
    if vim.b["max_line_length"] == 0 then
      vim.b["max_line_length"] = vim.fn.input("What is the line length? ")
    end
    if vim.fn.strlen(vim.fn.getline(".")) >= tonumber(vim.b["max_line_length"]) then
      vim.cmd([[ call cursor('.', b:max_line_length) ]])
      vim.cmd([[ execute "normal! F i\n" ]])
    end
  end
  ----------
end
----------

-- Lsp Mappings
----------
M.lsp_mappings = function()
  ----------
  -- Requires
  ----------
  local lk = require("config.keymaps").lk
  local nmap = require("config.utils").norm_keyset
  local descMap = require("config.utils").desc_keymap
  ----------
  --Mappings
  ----------
  nmap("[g", "lua vim.diagnostic.goto_prev()", "LSP: Previous Flag")
  nmap("]g", "lua vim.diagnostic.goto_next()", "LSP: Next Flag")
  nmap("[G", "lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})", "LSP: Next Error")
  nmap("]G", "lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})", "LSP: Previous Error")
  nmap("gw", "lua vim.diagnostic.open_float()", "LSP: Open Diagnostics Window")
  nmap("g=", "lua vim.lsp.buf.code_action()", "LSP: Take Code Action")
  nmap("gi", "lua require('config.utils').insertVirtualText()", "LSP: Function & Library Info")
  nmap("gL", "lua ShortenLine()", "LSP: Shorten Line")
  descMap({ "n" }, lk.codeAction, "R", ":lua vim.lsp.buf.rename()<CR>", "Code Action:  Rename Item Under Cursor")
  descMap(
    { "n" },
    lk.codeAction,
    "h",
    ":lua vim.lsp.buf.signature_help()<CR>",
    "Code Action:  Bring Up LSP Explanation"
  )
  descMap({ "n" }, lk.codeAction, "H", ":lua vim.lsp.buf.hover()<CR>", "Code Action:  Bring Up LSP Explanation")
  descMap({ "n" }, lk.codeAction, "I", ":checkhealth lsp<CR>", "Code Action:  Show Info")
  descMap(
    { "n" },
    lk.codeAction,
    "d",
    ":lua vim.cmd('vsplit'); vim.lsp.buf.definition()<CR>",
    "Code Action:  Go To Definition"
  )
  descMap({ "n" }, lk.codeAction, "D", ":lua vim.lsp.buf.declaration()<CR>", "Code Action:  Go To Declaration")
  descMap({ "n" }, lk.codeAction, "i", ":lua vim.lsp.buf.implementation()<CR>", "Code Action:  Go To Implementation")
  descMap(
    { "n" },
    lk.codeAction,
    "v",
    ":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
    "Code Action:  Toggle Inlay Hints"
  )
  descMap(
    { "n" },
    lk.codeAction,
    "r",
    ":lua require('telescope.builtin').lsp_references()<CR>",
    "Code Action:  Go to References"
  )
  descMap(
    { "n" },
    lk.codeAction,
    "t",
    ":lua require('telescope.builtin').lsp_type_definitions()<CR>",
    "Code Action:  Go To Type Definition"
  )
  descMap({ "n" }, lk.codeAction, "p", ":lua require('telescope.builtin').diagnostics()<CR>", "Show all Diagnostics")
  descMap({ "n" }, lk.codeAction, "=", ":lua vim.diagnostic.setqflist<CR>", "Quick Fix List")
  descMap(
    { "n" },
    lk.codeAction,
    "sw",
    ":lua require('telescope.builtin').lsp_workspace_symbols.key()<CR>",
    "Code Action Symbols: Show Workspace Symbols"
  )
  descMap(
    { "n" },
    lk.codeAction,
    "sd",
    ":lua require('telescope.builtin').lsp_document_symbols()<CR>",
    "Code Action Symbols: Show Document Symbols"
  )
  ----------
end
----------

--------------------------------
-- Beautify Function
--------------------------------

Lint_and_format = function()
  require("conform").format({
    async = true,
    lsp_fallback = true,
    callback = function()
      require("lint").try_lint()
      vim.print("Formatted & Linted")
    end,
  })
end

--------------------------------
-- Formatter
--------------------------------

-- Setup
----------
M.formatter_config = function()
  ----------
  -- Options
  ----------
  require("config.utils").norm_keyset(
    require("config.keymaps").lk.codeAction_format.key,
    'lua require("conform").format({async= true, lsp_fallback = false})<CR>: lua require("lint").try_lint()<CR>:lua vim.print("Formatted & Linted")',
    "LSP: Beautify Code"
  )
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  vim.lsp.buf.format = {
    timeout = 10000,
  }
  ----------
end
----------

--------------------------------
-- Linter Setup
--------------------------------

-- Setup
----------
M.linter_config = function()
  ----------
  -- Options
  ----------
  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost", "InsertLeave", "BufEnter" }, {
    callback = function(args)
      require("lint").try_lint()
    end,
  })
  ----------
  -- Mappings
  ----------
  require("config.utils").norm_keyset(
    require("config.keymaps").lk.codeAction_lint.key,
    'lua require("conform").format({async= true, lsp_fallback = false})<CR>: lua require("lint").try_lint()<CR>:lua vim.notify("Formatted & Linted", vim.log.levels.INFO)',
    "LSP: Try Lint"
  )
  ----------
end
----------

--------------------------------
-- Attach Injected
--------------------------------
M.injected_setup = function()
  local nmap = require("config.utils").norm_keyset
  local bo = vim.bo
  local lk = require("config.keymaps").lk
  local lreq = "lua require"
  local otter_start = function()
    local otter = require("otter")
    local filetype = bo.filetype
    if filetype == "python" then
      otter.activate({ "htmldjango", "html", "sql" })
    end
    if filetype == "qmd" then
      otter.activate({ "python" })
    end
    nmap(
      lk.codeAction_injectedLanguage .. "d",
      lreq .. '"otter".ask_definition()',
      "Code Action Injected: Show Definition"
    )
    nmap(
      lk.codeAction_injectedLanguage .. "t",
      lreq .. '"otter".ask_type_definition()',
      "Code Action Injected: Show Type Definition"
    )
    nmap(lk.codeAction_injectedLanguage .. "I", lreq .. '"otter".ask_hover()', "Code Action Injected: Show Info")
    nmap(
      lk.codeAction_injectedLanguage .. "s",
      lreq .. '"otter".ask_document_symbols()',
      "Code Action Injected: Show Symbols"
    )
    nmap(lk.codeAction_injectedLanguage .. "R", lreq .. '"otter".ask_rename()', "Code Action Injected: Rename")
    nmap(lk.codeAction_injectedLanguage .. "f", lreq .. '"otter".ask_format()', "Code Action Injected: Format")
  end
  vim.api.nvim_create_user_command("OtterActivate", function()
    otter_start()
  end, {})
end
----------

--------------------------------
-- UI Stuff
--------------------------------

-- LSP Signs
----------
-- Function to set them
M.set_signs = function()
  local icons = { Error = "󰅙 ", Warn = " ", Hint = " ", Info = " " }
  vim.diagnostic.config({
    signs = {
      active = true,
      text = {
        [vim.diagnostic.severity.ERROR] = icons.Error,
        [vim.diagnostic.severity.WARN] = icons.Warn,
        [vim.diagnostic.severity.HINT] = icons.Hint,
        [vim.diagnostic.severity.INFO] = icons.Info,
      },
      numhl = "", -- To clear the number highlight if you don't want it
    },
  })
end
----------

--------------------------------
-- Module Table
--------------------------------

return M

----------
