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
  nmap("g=", "lua vim.lsp.buf.code_action()", "LSP: Take Code Action")
  nmap("gi", "lua require('config.utils').insertVirtualText()", "LSP: Function & Library Info")
  descMap({ "n" }, lk.codeAction, "w", ":lua vim.diagnostic.open_float()<CR>", "LSP: Open Diagnostics Window")
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
-- LSP Setup
--------------------------------

-- Capabilities Attach Function
----------
-- On Attach
M.on_attach = function(client, bufnr)
  M.lsp_options()
  M.lsp_mappings()
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

-- Capabilities
M.capabilities = function()
  return vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("blink.cmp").get_lsp_capabilities({}, false)
  )
end

-- Setup Func
----------
M.setup = function(name, settings)
  settings = settings or {}
  settings.on_attach = settings.on_attach or M.on_attach
  settings.capabilities = settings.capabilities or M.capabilities()
  vim.lsp.config(name, settings)
  if name ~= "*" then
    vim.lsp.enable(name)
  end
end
----------

--------------------------------
-- Diagnostics
--------------------------------j

-- Diagnostics Setup
----------
-- Function to set them
M.diagnostics = function()
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
    },
    virtual_lines = false,
    current_line = true,
    virtual_text = false,
    update_on_insert = true,
  })
end
----------

--------------------------------
-- Beautify Function
--------------------------------

M.lint_and_format = function()
  if vim.is_callable(vim.b.ft_format) then
    vim.print("Running a special format for filetype: " .. vim.bo.filetype)
    vim.b.ft_format()
  else
    require("conform").format({
      async = true,
      lsp_fallback = true,
      callback = function()
        require("lint").try_lint()
        vim.print("Formatted & Linted")
      end,
    })
  end
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
  local lk = require("config.keymaps").lk
  local descMap = require("config.utils").desc_keymap
  descMap({ "n" }, lk.codeAction, "f", M.lint_and_format, "LSP: Beautify Code")
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

-- Linter Info
----------
M.lint_info = function()
  local filetype = vim.bo.filetype
  local linters = require("lint").linters_by_ft[filetype]
  if linters then
    print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
  else
    print("No linters configured for filetype: " .. filetype)
  end
end
----------

--------------------------------
-- Module Table
--------------------------------

return M

----------
