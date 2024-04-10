-------------------------------
-- ########################  --
-- # Lsp Mappings Config  #  --
-- ########################  --
-------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
-- Api Exposures
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local lsp = vim.lsp -- Lsp inbuilt
local b = vim.b -- buffer variables
G = vim.g -- global variables
--------

-- Requires
----------
local putils = require("personal_utils")
local lm = require("leader_mappings")
local cmp_setup = require("lsp.cmp_setup")
----------

-- Extra Vars
----------
local nmap = putils.norm_keyset
----------

-- Compressing Text w/Vars
----------
local lreq = "lua require"
----------

-- Functions
----------
-- Shorten Lines -- Note this will be janky but its set for improvement
function ShortenLine()
  if b["max_line_length"] == 0 then
    b["max_line_length"] = fn.input("What is the line length? ")
  end
  if fn.strlen(fn.getline(".")) >= tonumber(b["max_line_length"]) then
    cmd([[ call cursor('.', b:max_line_length) ]])
    cmd([[ execute "normal! F i\n" ]])
  end
end

--------------------------------
-- Lsp Mappings
--------------------------------

local keymaps = function(client)
  b["max_line_length"] = 0 -- This has to be attached to the buffer so I went for a bufferopt

  -- Mappings
  ----------
  -- Commands that keep you in this buffer `g`
  nmap("gw", "lua vim.diagnostic.open_float()", "LSP: Open Diagnostics Window")
  nmap("g=", "lua vim.lsp.buf.code_action()", "LSP: Take Code Action")
  nmap("gi", "lua vim.lsp.buf.hover()", "LSP: Function & Library Info")
  nmap("gL", "lua ShortenLine()", "LSP: Shorten Line")
  nmap("gf", "lua require("conform").format({ async = true, lsp_fallback = true }); vim.print(\"Formatted\")", "LSP: Format Code")
  nmap("[g", "lua vim.diagnostic.goto_prev()", "LSP: Previous Flag")
  nmap("]g", "lua vim.diagnostic.goto_next()", "LSP: Next Flag")
  nmap("[G", "lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})", "LSP: Next Error")
  nmap("]G", "lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})", "LSP: Previous Error")
  nmap(lm.codeAction .. "q", "LSPRestart", "LSP: Previous Error")
  nmap(lm.codeAction .. "R", "lua vim.lsp.buf.rename()", "LSP: Rename Item Under Cursor")
  nmap(lm.codeAction .. "h", "lua vim.lsp.buf.signature_help()", "LSP: Bring Up LSP Explanation")
  nmap(lm.codeAction .. "I", "LspInfo", "LSP: Show Info")
  nmap(lm.codeAction .. "D", "lua vim.lsp.buf.definition()", "LSP: Go To Definition")
  nmap(lm.codeAction .. "d", "lua vim.lsp.buf.declaration()", "LSP: Go To Declaration")
  nmap(lm.codeAction .. "i", "lua vim.lsp.buf.implementation()", "LSP: Go To Implementation")
  nmap(lm.codeAction .. "r", lreq .. "('telescope.builtin').lsp_references()", "LSP: Go to References")
  nmap(lm.codeAction .. "t", lreq .. "('telescope.builtin').lsp_type_definitions()", "LSP: Go To Type Definition")
  nmap(lm.codeAction .. "p", lreq .. "('telescope.builtin').diagnostics()", "Show all Diagnostics")
  nmap(lm.codeAction .. "=", "lua vim.diagnostic.setqflist", "Quick Fix List")
  nmap(lm.codeAction_symbols .. "w", lreq .. "('telescope.builtin').lsp_workspace_symbols()", "Show Workspace Symbols")
  nmap(lm.codeAction_symbols .. "d", lreq .. "('telescope.builtin').lsp_document_symbols()", "Show Document Symbols")

  lsp.handlers["textDocument/hover"] =
    lsp.with(lsp.handlers.hover, { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } })
  lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(lsp.handlers.signature_help, { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } })
end

--------------------------------
-- Local On_attach
--------------------------------

-- Buffer Config
----------
-- On attach function
local on_attach = function(client, bufnr)
  -- Omnifunc use lsp
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- FormatExpr use lsp
  api.nvim_buf_set_option(0, "formatexpr", "v:lua.require'conform'.formatexpr()")
  -- Attach Keymappings
  keymaps(client)
  -- Format Timeout
  lsp.buf.format({ timeout = 10000 }) -- Format Timeout
end

--------------------------------
-- Lsp Std Opts
--------------------------------

-- Standard Opts
local lsp_opts = function(opts)
  local standardOpts = {
    on_attach = on_attach,
    capabilities = cmp_setup.capabilities(),
    flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
    },
  }
  for k, v in pairs(standardOpts) do
    opts[k] = v
  end
  return opts
end
----------

--------------------------------
-- Module Table
--------------------------------

local M = {
  keymaps = keymaps,
  on_attach = on_attach,
  capabilities = cmp_setup.capabilities,
  options = lsp_opts
}

return M

----------
