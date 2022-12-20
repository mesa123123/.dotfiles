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
-- Api Exposures
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local keymap = vim.keymap -- keymaps
local lsp = vim.lsp -- Lsp inbuilt
-- Options
local bo = vim.bo -- bufferopts
-- For Variables
local b = vim.b -- buffer variables
--------

-- Required Module Loading Core Lsp Stuff
----------
local config = require("lspconfig") -- Overall configuration for lsp
local install = require("mason-lspconfig") -- Mason is the successor to lsp-installer
local cmp = require "cmp" -- Autocompletion for the language servers
local cmp_lsp = require("cmp_nvim_lsp")
local dap = require("dap")
local snip = require("luasnip")
local snipload_lua = require("luasnip.loaders.from_lua")
--------

-- Required Extras
----------
local path = config.util.path
local dapui = require("dapui")
local cmpsnip = require("cmp_luasnip")
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
-- Utility Functions
--------------------------------

-- Find if a file exists
----------
local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then io.close(f) return true else return false end
end

----------

--------------------------------
-- Snippets
--------------------------------

-- Config
----------
snip.config.set_config({
    updateevents = "TextChanged,TextChangedI",
})
----------

-- Load Snippets
----------
local snips_folder_lua = fn.stdpath "config" .. "/lua/snippets/"
snipload_lua.lazy_load { paths = snips_folder_lua }

-- Functions
----------
function SnipEditFile()
    local snips_file = snips_folder_lua .. bo.filetype .. ".lua"
    if not file_exists(snips_file) then
        io.open(snips_file)
    end
    cmd("e " .. snips_file)
end

-- Commands
----------
cmd [[command! LuaSnipEdit :lua SnipEditFile()]]

-- Mappings
----------
keymap.set("t", "<leader>se", ":LuaSnipEdit", {})

--------------------------------
-- Completion
--------------------------------

-- Support Functions
----------
-- Helps Cmd when theres no characters already there
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
----------

-- Shorten Lines
----------
-- Note this will be janky but its set for improvement
function ShortenLine()
    if b['max_line_length'] == 0 then
        b['max_line_length'] = fn.input("What is the line length? ")
    end
    if fn.strlen(fn.getline('.')) >= tonumber(b['max_line_length']) then
        cmd [[ call cursor('.', b:max_line_length) ]]
        cmd [[ execute "normal! F i\n" ]]

    end
end

-- Confirm Formatting
----------
function FormatWithConfirm()
    vim.lsp.buf.format()
    print("Formatted")
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
                nvim_lsp = "[Lsp]",
                buffer = "[Buffer]",
                nvim_lua = "[Lua]",
                luasnip = "[Snip]",
                treesitter = "[Treesitter]",
            })[entry.source.name]
            return vim_item
        end,
    },
    -- Mappings
    ----------
    mapping = {
        -- Go to Next Item
        ["<c-l>"] = cmp.mapping(function(fallback)
            if snip.jumpable(1) then
                snip.jump(1)
            elseif cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s", "c" }),
        -- Go to Previous Item
        ["<c-h>"] = cmp.mapping(function(fallback)
            if snip.jumpable(-1) then
                snip.jump(-1)
            elseif cmp.visible() then
                cmp.select_prev_item()
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
        ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.confirm()
            elseif snip.expandable() and has_words_before then
                snip.expand_or_jump()
            else
                fallback()
            end
        end, { "i" }),
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
local capabilities = cmp_lsp.default_capabilities(lsp.protocol.make_client_capabilities())
----------

--------------------------------
-- Language Server Key Mappings
--------------------------------

-- Mappings
----------
local function keymappings(client)
    -- Mapping Opts
    ----------
    local bufopts = { noremap = true, silent = true, buffer = 0 }
    local loudbufopts = { noremap = true, silent = false, buffer = 0 }
    b['max_line_length'] = 0 -- This has to be attached to the buffer so I went for a bufferopt
    -- Mappings
    ----------
    -- Commands that keep you in this buffer `g`
    keymap.set("n", "gw", ":lua vim.diagnostic.open_float()<CR>", bufopts)
    keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
    keymap.set("n", "[g", ":lua vim.diagnostic.goto_prev()<CR>", bufopts)
    keymap.set("n", "]g", ":lua vim.diagnostic.goto_next()<CR>", bufopts)
    keymap.set("n", "[G", ":lua vim.diagnostic.goto_prev({severity = diagnostic.severity.ERROR})<CR>", bufopts)
    keymap.set("n", "]G", ":lua vim.diagnostic.goto_next({severity = diagnostic.severity.ERROR})<CR>", bufopts)
    keymap.set("n", "g=", ":lua vim.lsp.buf.code_action()<CR>", bufopts)
    keymap.set("n", "gl", ":lua ShortenLine()<CR>", bufopts)
    if client.server_capabilities.documentFormattingProvider then
        keymap.set("n", "gf", ":lua FormatWithConfirm()<CR>", loudbufopts)
        print("Formatter Accepted")
    else
        print("There Is No Formatter Attached!")
    end
    -- Commands where you leave current buffer `<leader>c`
    keymap.set("n", "<leader>cR", "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
    keymap.set("n", "<leader>cI", "<cmd>LspInfo<CR>", bufopts)
    -- Need something here that says (if implementation isn't supported open definition/declaration in new buffer
    keymap.set("n", "<leader>cD", "<Cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
    keymap.set("n", "<leader>cd", "<Cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
    keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.buf.references()<CR>", bufopts)
    keymap.set("n", "<leader>cs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
    keymap.set("n", "<leader>ci", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
    keymap.set("n", "<leader>ct", "<cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
    ----------
end

----------

--------------------------------
-- Language Server Configuration
--------------------------------

-- Buffer Config
----------
-- On attach function
local function on_attach(client, bufnr)
    -- Omnifunc use lsp
    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- FormatExpr use lsp
    api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    -- Attach Keymappings
    keymappings(client)
end

----------

-- General Config
----------
lsp.buf.format(nil, 10000) -- Format Timeout
----------

--------------------------------
-- Configuration of Installer
--------------------------------

-- Dependent Modules Require
----------
require("mason").setup({
    install_root_dir = os.getenv("HOME") .. "/.config/nvim/lua/lsp_servers"
}) -- Mason is the engine the installer configs will run
----------

-- Ensure Installs
----------
install.setup({ automatic_installation = true,
    ensure_installed = { 'sumneko_lua', 'pyright',
        'bashls', 'cucumber_language_server', 'tsserver',
        'rust_analyzer', 'sqlls' } }) -- This is running through Mason_lsp-config
----------
local other_servers = { 'pylint', 'depugpy', 'markdownlint', 'shellcheck', 'black', 'prettier', 'sql-formatter' }
--------------------------------
-- Setup of Language Servers
--------------------------------

-- Functions
----------
-- Find Python Virutal_Env
local function get_python_path()
    -- Use Activated Environment
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end
    -- Fallback to System Python
    return fn.exepath('python3') or fn.exepath('python') or 'python'
end

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

-- Python: Pyright
----------
config.pyright.setup { on_attach = on_attach, capabilities = capabilities,
    on_init = function(client)
        client.config.settings.python.pythonPath = get_python_path()
    end
}
----------

-- Web: Tsserver
----------
config.tsserver.setup({
    capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = function(client)
        client.server_capabilities.document_formatting = false
    end,
})
----------

-- Cucumber
----------
config.cucumber_language_server.setup { on_attach = on_attach, capabilities = capabilities }
----------

-- Bash
----------
config.bashls.setup { on_attach = on_attach, capabilities = capabilities }
----------

-- Yaml
----------
config.yamlls.setup { on_attach = on_attach, capabilities = capabilities }
----------

-- SQL
----------
config.sqlls.setup { on_attach = on_attach, capabilities = capabilities, 
    root_dir =  config.util.root_pattern("*.sql")
}
----------

-- Rust Server
----------
config.rust_analyzer.setup { on_attach = on_attach, capabilities = capabilities, settings = {
    ['rust-analyzer'] = {
        checkOnSave = {
            command = "clippy"
        }
    }
}
}
----------

--------------------------------
-- Setup of Null-ls
--------------------------------

-- Import Null-ls
----------
local nullls = require("null-ls")
local method = nullls.methods
local format = nullls.builtins.formatting -- Formatting
local diagnose = nullls.builtins.diagnostics -- Diagnostics
local code_actions = nullls.builtins.code_actions
local hover = nullls.builtins.hover
local register = nullls.register
local helpers = require("null-ls.helpers")
----------

-- Functions
----------
-- Get Virtual Env Packages as NullLsp
local function get_venv_command(command)
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, 'bin', command)
    else
        return command
    end
end

----------

-- Installed Mason Managed Sources (I prefer these because they'll sit with everything else)
----------
local nullSources     = {}
-- Need something in here that says like if pyproject is there, look in there, if not find mason
local mason_installed = require("mason-registry")
for _, package in pairs(mason_installed.get_installed_package_names()) do
    -- Python Packages
    -----------
    -- Pylint
    if package == "pylint" then -- Pylint
        nullSources[#nullSources + 1] = diagnose.pylint.with({
            command = get_venv_command("pylint"),
            on_init = function(client)
                client.config.settings.python.pythonPath = get_python_path()
            end,
            on_attach = on_attach
        })
    end
    -- Black
    if package == "black" then --Python Formatter
        nullSources[#nullSources + 1] = format.black.with({
            command = get_venv_command("black"),
            on_init = function(client)
                client.config.settings.python.pythonPath = get_python_path()
            end,
            on_attach = on_attach
        })
    end
    -- Shell
    ----------
    -- Shellcheck
    if package == "shellcheck" then
        nullSources[#nullSources + 1] = code_actions.shellcheck.with({ on_attach = on_attach })
    end
    -- Yaml
    ----------
    if package == "yamllint" then
        nullSources[#nullSources + 1] = diagnose.yamllint.with({ on_attach = on_attach })
    end
    ----------
    if package == "markdownlint" then
        nullSources[#nullSources + 1] = diagnose.markdownlint.with({
            on_attach = on_attach,
            autostart = true
        })
        nullSources[#nullSources + 1] = format.markdownlint
    end
    ----------
    -- Prettier
    if package == "prettier" then
        nullSources[#nullSources + 1] = format.prettier.with({
            on_attach = on_attach,
            filetypes = {
                "javascript", "typescript", "css", "scss", "html", "json", "graphql"
            },
        })
    end
    ----------
end
------------

-- Load the Mason Packages into the Null-ls engine
----------
nullls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    debug = true,
    sources = { sources = nullSources },
}
----------

--------------------------------
-- Colors and Themes
--------------------------------
local hl = api.nvim_set_hl

hl(0, 'LspDiagnosticsUnderlineError', { bg = '#EB4917', underline = true, blend = 50 })
hl(0, 'LspDiagnosticsUnderlineWarning', { bg = '#EBA217', underline = true, blend = 50 })
hl(0, 'LspDiagnosticsUnderlineInformation', { bg = '#17D6EB', underline = true, blend = 50 })
hl(0, 'LspDiagnosticsUnderlineHint', { bg = '#17EB7A', underline = true, blend = 50 })


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

-- Setup Dap-Ui
dapui.setup()

-------------------------------
-- EOF
-------------------------------
