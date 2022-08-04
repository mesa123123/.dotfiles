--------------------------------
-- ########################## --
-- # Lsp And Related Setups # --
-- ########################## --
--------------------------------

--------------------------------
-- Luaisms for Vim Stuff
--------------------------------

-- Variables
----------
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local keymap = vim.keymap -- keymaps
local lsp = vim.lsp
local g = vim.g -- global variables
local opt = vim.opt -- vim options
local gopt = vim.o -- global options
local bopt = vim.bo -- buffer options
local wopt = vim.wo -- window options
--------

-- Required Module Loading Core Lsp Stuff
----------
local config = require("lspconfig") -- Overall configuration for lsp
local install = require("mason-lspconfig") -- Mason is the successor to lsp-installer
local cmp = require "cmp" -- Autocompletion for the language servers
local cmp_lsp = require("cmp_nvim_lsp")
--------

-- Required Extras
----------
local sig = require("lsp_signature") -- Lsp Signatures
local nullls = require("null-ls") -- Other goodies like formatting
local snip = require("luasnip")
local notify = require("notify")

--------------------------------
-- Snippets
--------------------------------

-- Config
----------
snip.config.set_config {
    updateevents = "TextChanged,TextChangedI"
}
----------

--------------------------------
-- Completion
--------------------------------

-- Support Functions
----------
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
----------

-- General Config
----------
cmp.setup({
    -- Enable for only where I want it
    ----------
    enabled = { function()
        local context = require 'cmp.config.context' -- disable completion in comments
        if vim.api.nvim_get_mode().mode == 'c' then -- keep command mode completion enabled when cursor is in a comment
            return true
        else
            return not context.in_treesitter_capture("comment")
                and not context.in_syntax_group("Comment")
        end
    end },
    -- I'm not sure what this does, @TODO
    completion = { completeopt = "menu,menuone,noinsert", keyword_length = 1 },
    -- Set Snippets Engine
    snippet = {
        expand = function(args)
            snip.lsp_expand(args.body)
        end
    },
    -- Making autocomplete menu look nice
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                buffer = "[Buffer]",
                luasnip = "[Snip]",
                nvim_lua = "[Lua]",
                treesitter = "[Treesitter]",
            })[entry.source.name]
            return vim_item
        end,
    },
    -- Attach all the extensions
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'treesitter' },
        { name = 'cmdline' }
    },
    -- Mappings
    ----------
    mapping = {
        -- Go to Next Item
        ["<c-l>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif snip.expand_or_jumpable() then
                snip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s", "c" }),
        -- Go to Previous Item
        ["<c-h>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif snip.jumpable(-1) then
                snip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s", "c" }),
        -- Use Esc to Abort (and back to normal mode)
        ["<Esc>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.abort()
                cmd('stopinsert')
            else
                fallback()
            end
        end, { "i", "s", "c" }),
        -- Use Enter to Select
        ["<CR>"] = cmp.mapping {
            i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
        },
        -- Use <Tab> to call upon the cmp when needed
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
            else
                cmp.complete()
            end
        end, { "c" }),
        ["<c-Space>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.close()
            else
                cmp.complete()
            end
        end, { "i", 's' }),
    },
    window = {
        completion = cmp.config.window.bordered({
            border = 'rounded'
        }),
        documentation = cmp.config.window.bordered({
            border = 'rounded'
        }),
    },
})

----------

-- Config Text Search '/'
----------
cmp.setup.cmdline("/", {
    sources = {
        { name = 'buffer' },
    },
})
----------

-- Config Commandline ':'
----------
cmp.setup.cmdline(":", {
    sources = {
        { name = 'cmdline' },
        { name = 'path' },
    },
})
----------

-- Git Commit Setup
----------
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})
----------

-- Add Cmp Capabilities
----------
local capabilities = cmp_lsp.update_capabilities(lsp.protocol.make_client_capabilities())
----------

--------------------------------
-- Key Mappings
--------------------------------

-- Mappings
----------
local function keymappings(client)
    -- Mapping Opts
    ----------
    local bufopts = { noremap = true, silent = true, buffer = 0 }
    local loudbufopts = { noremap = true, silent = false, buffer = 0 }
    ----------
    -- Mappings
    ----------
    -- Commands that keep you in this buffer `g`
    keymap.set("n", "gw", ":lua vim.diagnostic.open_float()<CR>", bufopts)
    keymap.set("n", "[g", ":lua vim.diagnostic.goto_prev()<CR>", bufopts)
    keymap.set("n", "]g", ":lua vim.diagnostic.goto_next()<CR>", bufopts)
    keymap.set("n", "[G", ":lua vim.diagnostic.goto_prev({severity = diagnostic.severity.ERROR})<CR>", bufopts)
    keymap.set("n", "]G", ":lua vim.diagnostic.goto_next({severity = diagnostic.severity.ERROR})<CR>", bufopts)
    keymap.set("n", "g=", ":lua vim.lsp.buf.code_action()<CR>", bufopts)
    if client.resolved_capabilities.document_formatting then
        keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>", loudbufopts)
    end
    -- Commands where you leave current buffer `<leader>c`
    keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
    keymap.set("n", "<leader>cI", "<cmd>LspInfo<CR>", bufopts)
    keymap.set("n", "<leader>cD", "<Cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
    keymap.set("n", "<leader>cd", "<Cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
    keymap.set("n", "<leader>cs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
    keymap.set("n", "<leader>ci", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
    keymap.set("n", "<leader>ct", "<cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
    ----------
end

----------

--------------------------------
-- Language Server Handlers
--------------------------------

-- Create on Attach Function
----------
local function on_attach(client, bufnr)
    -- Omnifunc use lsp
    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- FormatExpr use lsp
    api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    -- Attach Keymappings
    keymappings(client)
end

----------

--------------------------------
-- Configuration of Installer
--------------------------------

-- Dependent Modules Require
----------
require("mason").setup({ install_root_dir = "/Users/m808752/.config/nvim/lua/lsp_servers" }) -- Mason is the engine the installer configs will run
----------

-- Ensure Installs
----------
install.setup({ automatic_installation = true, ensure_installed = { 'sumneko_lua', 'pyright' } }) -- This is running through Mason_lsp-config
----------

--------------------------------
-- Setup of Language Servers
--------------------------------

-- Lua: Language Server
----------
config.sumneko_lua.setup { on_attach = on_attach, capabilities = capabilities,
    -- Config
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim', 'use' }, }, -- Makes sure that vim, packer global errors dont pop up
            workspace = {
                library = api.nvim_get_runtime_file("", true),
                checkThirdParty = false, -- Stops annoying config prompts
            },
            completion = { autoRequire = false },
            telemetry = { enable = false }, -- Don't steal my data
        },
    },
}
----------

-- Pyright
----------
config.pyright.setup { on_attach = on_attach, capabilities = capabilities }
----------

--------------------------------
-- Setup of Null-ls (Third Party Lsp Goodies)
--------------------------------

local formatting = nullls.builtins.formatting
local diagnostics = nullls.builtins.diagnostics

nullls.setup {
    on_attach = on_attach,
    debug = true,
    sources = {
        -- Python Extras
        ----------
        formatting.autopep8,
        diagnostics.pylint.with({
            prefer_local = "./.venv/bin" -- make pylint look for the virtual environment
        })
        ----------
    }
}

--------------------------------
-- Colors and Themes
--------------------------------
local hl = api.nvim_set_hl

hl(0, 'LspDiagnosticsUnderlineError', { bg = '#EB4917', underline = true, blend = 50 })
hl(0, 'LspDiagnosticsUnderlineWarning', { bg = '#EBA217', underline = true, blend = 50 })
hl(0, 'LspDiagnosticsUnderlineInformation', { bg = '#17D6EB', underline = true, blend = 50 })
hl(0, 'LspDiagnosticsUnderlineHint', { bg = '#17EB7A', underline = true, blend = 50 })

----------

-------------------------------
-- EOF
-------------------------------
