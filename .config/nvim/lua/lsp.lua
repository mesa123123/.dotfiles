--------------------------------
-- ########################## --
-- # Lsp And Related Setups # --
-- ########################## --
--------------------------------

------------------------
-- TODO

-- 1. figure out why language servers aren't installing where I tell them
-- 2. figoure out cmp integration

------------------------


--------------------------------
-- Luaisms for Vim Stuff
--------------------------------

-- Variables
----------
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local keymap = vim.keymap
local g = vim.g -- global variables
local opt = vim.opt -- vim options
local gopt = vim.o -- global options
local bopt = vim.bo -- buffer options
local wopt = vim.wo -- window options

--------

-- Required Module Loading
----------
local lspconfig = require("lspconfig")
local whichkey = require("which-key")
local lspinstall = require("nvim-lsp-installer")
local lspsig = require("lsp_signature")
local lspcmp = require("cmp_nvim_lsp")

-- Setup Modules
----------
--------

-- Add Cmp Capabilities
----------
local capabilities = lspcmp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

--------------------------------
-- LSP Install Config
--------------------------------
-- Setup Root Dir
lspinstall['install_root_dir'] = "/home/$USER/.config/nvim/lua/lsp_servers"
-- UI Config
lspinstall['ui'] = { check_outdated_servers_on_open = true }

----------

--------------------------------
-- Key Mappings
--------------------------------

local function keymappings(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = 0 }
    local opts = { noremap = true, silent = true }
   -- Mappings 
   ----------
    keymap.set("n", "<leader>cw", ":lua vim.diagnostic.open_float()<CR>", bufopts)
    keymap.set("n", "[g", ":lua vim.diagnostic.goto_prev()<CR>", bufopts)
    keymap.set("n", "]g", ":lua vim.diagnostic.goto_next()<CR>", bufopts)
    keymap.set("n", "[G", ":lua vim.diagnostic.goto_prev({severity = diagnostic.severity.ERROR})<CR>", bufopts)
    keymap.set("n", "]G", ":lua vim.diagnostic.goto_next({severity = diagnostic.severity.ERROR})<CR>", bufopts)
    keymap.set("n", "g=", ":lua vim.lsp.buf.code_action()<CR>", bufopts)
      -- Whichkey
    local keymap_l = {
        l = {
              name = "Code",
              r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
              a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
              d = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Line Diagnostics" },
              i = { "<cmd>LspInfo<CR>", "Lsp Info" },
        },
    }
    if client.resolved_capabilities.document_formatting then
        keymap_l.l.f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Document" }
    end

    local keymap_g = {
        name = "Goto",
        d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
        D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
        s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
        I = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
        t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
    }
    whichkey.register(keymap_l, { buffer = bufnr, prefix = "<leader>" })
    whichkey.register(keymap_g, { buffer = bufnr, prefix = "g" })
end

----------

----------------------------------------
-- Attaching the Language Server
----------------------------------------

-- Create on Attach Function
----------
local function on_attach(client, bufnr)
    -- Omnifunc use lsp
    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- FormatExpr use lsp
    api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    -- Get KeyMappings
    keymappings(client, bufnr)
end


--------------------------------
-- Configuration of Servers 
--------------------------------

-- Ensure Installs
----------
lspinstall.setup({ automatic_installation = true, ensure_installed = { 'sumneko_lua', 'pyright' }, install_root_dir = "/home/$USER/.config/nvim/lua/lsp_servers"})

-- Setup
----------
-- Lua: lua-language-server
lspconfig.sumneko_lua.setup { on_attach = on_attach, capabilities = capabilities }
-- Python: pyright
lspconfig.pyright.setup { on_attach = on_attach, capabilities = capabilities }
