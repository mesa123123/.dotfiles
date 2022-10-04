--------------------------------
-- ########################## --
-- # Lsp And Related Setups # --
-- ########################## --
--------------------------------

-------------------------------- Luaisms for Vim Stuff
--------------------------------

-- Variables
----------
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local keymap = vim.keymap -- keymaps
local g = vim.g -- global variables
local opt = vim.opt -- vim options
local gopt = vim.o -- global options
local bopt = vim.bo -- buffer options
local wopt = vim.wo -- window options
--------

-- Lsp Abbreviations
----------
local lsp = vim.lsp
local diagnose = vim.diagnostic
local format = vim.formatting
----------

-- Required Module Loading Core Lsp Stuff
----------
local config = require("lspconfig") -- Overall configuration for lsp
local install = require("mason-lspconfig") -- Mason is the successor to lsp-installer
local cmp = require "cmp" -- Autocompletion for the language servers
local cmp_lsp = require("cmp_nvim_lsp")
local dap = require("dap")
local snip = require("luasnip")
----------

-- Required Extras
----------
local sig = require("lsp_signature") -- Lsp Signatures
local nullls = require("null-ls") -- Other goodies like formatting
local notify = require("notify")
local dapui = require("dapui")
----------

--------------------------------
-- Language Specific Settings and Helpers
--------------------------------

-- Python Virtual Environments
----------
local venv_path = function()
    local venv = (os.getenv("VIRTUAL_ENV"))
    if venv == nil or venv == '' then
        return os.execute("which python")
    else
        local output = {}
        for match in string.gmatch(venv, "([^/]+)") do
            table.insert(output, match)
        end
        return vim.fn.getcwd() .. string.format("%s/bin/python", output[#output])
    end
end
----------

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
    local line, col = unpack(api.nvim_win_get_cursor(0))
    return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
        ["<Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
            else
                cmp.complete()
            end
        end, { "c" }),
        ["<c-Space>"] = cmp.mapping(function()
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
require("mason").setup({ install_root_dir = "/home/bowmanpete/.config/nvim/lua/lsp_servers" }) -- Mason is the engine the installer configs will run
----------

-- Ensure Installs
----------
install.setup({ automatic_installation = true,
    ensure_installed = { 'black', 'sumneko_lua', 'pyright', 'markdownlint', 'pylint', 'debugpy', 'shellcheck',
        'bash-debug-adapter', 'bash-language-server', 'rust-analyzer' } }) -- This is running through Mason_lsp-config
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
            completion = { autoRequire = true },
            telemetry = { enable = false }, -- Don't steal my data
        },
    },
}
----------

-- Python Servers
----------
-- Pyright
config.pyright.setup { on_attach = on_attach, capabilities = capabilities }

-- Rust Server
----------
config.rust_analyzer.setup { on_attach = on_attach, capabilities = capabilities }

--------------------------------
-- Setup of Null-ls (Turn Non-Lsps Into Lsps)
--------------------------------

-- Special variables for nullls
----------
local nformatting = nullls.builtins.formatting
local ndiagnostics = nullls.builtins.diagnostics
local ncompletion = nullls.builtins.completion
----------

-- Nullls Setup
----------
nullls.setup {
    on_attach = on_attach,
    sources = {
        -- Python Extras
        ----------
        nformatting.black.with({
            prefer_local = "./.venv/bin"
        }),
        ndiagnostics.pylint.with({
            prefer_local = "./.venv/bin" -- make pylint look for the virtual environment
        }),
        ----------
        -- Spell
        ----------
        ncompletion.spell,
    }
}
----------

--------------------------------
-- Debug Adapter Protocol
--------------------------------

-- Mappings
----------
local keyopts = { silent = true, noremap = true }
-- Ui Commands
keymap.set("n", "<leader>bge", "<cmd>lua require'dapui'.eval()<cr>", keyopts)
keymap.set("n", "<leader>bge", "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", keyopts) -- bug gui exec
keymap.set("n", "<leader>bgo", "<cmd>lua require'dapui'.toggle()<cr>", keyopts) -- bug gui toggle
keymap.set("n", "<leader>bgh", "<cmd>lua require'dap.ui.widgets'.hover()<cr>", keyopts)
keymap.set("n", "<leader>bgs", "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", keyopts)
-- Session Commands
keymap.set("n", "<leader>bs", "<cmd>lua require'dap'.session()<cr>", keyopts)
keymap.set("n", "<leader>br", "<cmd>lua require'dap'.repl.toggle()<cr>", keyopts)
keymap.set("n", "<leader>bx", "<cmd>lua require'dap'.disconnect()<cr>", keyopts) -- bug exit
keymap.set("n", "<leader>bq", "<cmd>lua require'dap'.close()<cr>", keyopts)
keymap.set("n", "<leader>bQ", "<cmd>lua require'dap'.terminate()<cr>", keyopts)
-- Breakpoints (and pauses)
keymap.set("n", "<leader>bB", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", keyopts) -- bug breakpoint
keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", keyopts)
keymap.set("n", "<leader>bp", "<cmd>lua require'dap'.pause.toggle()<cr>", keyopts)
-- Stepping commands
keymap.set("n", "<leader>bh", "<cmd>lua require'dap'.run_to_cursor()<cr>", keyopts) -- run to here
keymap.set("n", "<leader>bl", "<cmd>lua require'dap'.continue()<cr>", keyopts) -- bug continue
keymap.set("n", "<leader>bh", "<cmd>lua require'dap'.step_back()<cr>", keyopts) -- bug previous
keymap.set("n", "<leader>bj", "<cmd>lua require'dap'.step_into()<cr>", keyopts)
keymap.set("n", "<leader>bk", "<cmd>lua require'dap'.step_over()<cr>", keyopts)
keymap.set("n", "<leader>b", "<cmd>lua require'dap'.step_out()<cr>", keyopts)
----------

-- Adapter Setup (Adapters are like LSP-handlers for a DAP)
----------
-- Python
dap.adapters.python = {
    type = "executable",
    command = os.getenv("HOME") .. "/.config/nvim/lua/lsp_servers/bin/debugpy"
}
----------

-- Debugger Configuration
----------
-- Get the pre-made stuff
require('dap-python').setup(venv_path())
table.insert(dap.configurations.python, {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}', -- launches the current file
        pythonPath = venv_path()
    }
})
----------

------------------------------
-- EOF
-------------------------------
