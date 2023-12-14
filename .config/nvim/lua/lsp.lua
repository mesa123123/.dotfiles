--------------------------
-- ###################  --
-- # Lsp Vim Config  #  --
-- ###################  --
--------------------------

--------------------------------
-- Luaisms for Vim Stuff
--------------------------------

-- Variables
----------
-- Api Exposures
local cmd = vim.cmd       -- vim commands
local api = vim.api       -- vim api (I'm not sure what this does)
local fn = vim.fn         -- vim functions
local keymap = vim.keymap -- keymaps
local lsp = vim.lsp       -- Lsp inbuilt
local log = vim.log
-- Options
local bo = vim.bo          -- bufferopts
-- For Variables
local b = vim.b            -- buffer variables
G = vim.g                  -- global variables
local hl = api.nvim_set_hl -- highlighting
--------

-- Required Module Loading Core Lsp Stuff
----------
local config = require("lspconfig") -- Overall configuration for lsp
local tool_install = require("mason-tool-installer")
local cmp = require("cmp")          -- Autocompletion for the language servers
local cmp_lsp = require("cmp_nvim_lsp")
local dap = require("dap")
local lint = require("lint")
local format = require("conform")
local snip = require("luasnip")
local snipload_lua = require("luasnip.loaders.from_lua")
local snipload_vscode = require("luasnip.loaders.from_vscode")
local whichKey = require("which-key")
--------

-- Required Extras
----------
local path = config.util.path
local cmpsnip = require("cmp_luasnip")
local telescope = require("telescope")
local lspkind = require("lspkind")
local dapui = require("dapui")
--------------------------------
-- Language Specific Settings and Helpers
--------------------------------

-- Empty

--------------------------------
-- Utility Functions
--------------------------------

-- Find if a file exists
----------
local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

-- Merge two tables
----------
local function tableConcat(t1, t2)
    for _, v in ipairs(t2) do
        table.insert(t1, v)
    end
    return t1
end

-- Get Pyenv Packages if active
----------
local function get_venv_command(command)
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", command)
    else
        return command
    end
end
----------

--------------------------------
-- Installer and Package Management
--------------------------------

-- Dependent Modules Require
----------
local server_dir = os.getenv("HOME") .. "/.config/nvim/lua/lsp_servers"
require("mason").setup({
    install_root_dir = server_dir,
}) -- Mason is the engine the installer configs will run
----------

-- Package Installs
----------
-- Core Language Servers
local lsp_servers_ei = {
    "lua_ls",
    "pyright",
    "bashls",
    "cucumber_language_server",
    "tsserver",
    "rust_analyzer",
    "terraformls",
    "emmet_ls",
    "jsonls",
}
-- Formatters
local formatters_ei = { "shellharden", "sql-formatter", "eslint", "prettier", "djlint", "black", "jq", "stylua" }
-- Lineters
local linters_ei = { "pylint", "jsonlint", "luacheck", "markdownlint" }
-- Other Language Servers, Handled by Nullls
local other_servers = { "debugpy", "shellcheck", "prettier", "rstcheck", "write-good", "proselint" }
----------

-- Install Packages
----------
tool_install.setup({
    ensure_installed = tableConcat(formatters_ei, tableConcat(linters_ei, tableConcat(other_servers, lsp_servers_ei))),
    auto_update = true,
}) -- This is running through Mason_Tools_Installer
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
local snips_folder = fn.stdpath("config") .. "/lua/snippets/"
snipload_vscode.lazy_load()
snipload_lua.lazy_load({ paths = snips_folder })
require("luasnip.loaders.from_vscode").lazy_load()
----------

-- Functions
----------
function SnipEditFile()
    local snips_file = snips_folder .. bo.filetype .. ".lua"
    if not file_exists(snips_file) then
        io.open(snips_file)
    end
    cmd("e " .. snips_file)
end

----------

-- Commands
----------
api.nvim_create_user_command("LuaSnipEdit", ":lua SnipEditFile()<CR>", {})
----------

--------------------------------
-- Setup of Formatters - conform.nvim
--------------------------------

-- Setup
----------
format.setup({
    formatters = {
        black = { args = get_venv_command("black") },
        isort = { args = get_venv_command("isort") },
    },
    formatters_by_ft = {
        python = { "black", "isort" },
        lua = { "stylua" },
        javascript = { "prettier" },
        shell = { "shellharden" },
        json = { { "jq", "jsonls" } },
        markdown = { "markdownlint" },
    },
})

-- General Format Function
----------
function FormatWithConfirm()
    format.format({ async = true, lsp_fallback = false })
    print("Formatted")
end

----------

--Format Settings
----------
lsp.buf.format({ timeout = 10000 }) -- Format Timeout
----------

--------------------------------
-- Setup of Linters - nvim-lint
--------------------------------

-- Custom Linters Command
----------
-- Venved Pylint
local pylint = lint.linters.pylint
pylint.cmd = get_venv_command("pylint")
----------

-- Setup
----------
lint.linters_by_ft = {
    -- Python
    python = { "pylint" },
    -- Json
    json = { "jsonlint" },
    -- lua
    lua = { "luacheck" },
    -- Markdown
    markdown = { "markdownlint" },
}

api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufWinEnter", "BufEnter" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
----------

-- Configure Linters
----------
local markdownlint = lint.linters.markdownlint
markdownlint.args = {
    "--disable",
    "MD013",
    "MD012",
    "MD041",
}
----------

--------------------------------
-- Completion
--------------------------------

-- Support Functions
----------
-- Enablement for General Setup
local general_enabled = function()
    local context = require("cmp.config.context") -- disable completion in comments
    if vim.api.nvim_get_mode().mode == "c" then   -- keep command mode completion enabled when cursor is in a comment
        return true
    else
        return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
    end
end

-- Helps the completion decide whether to pop up, also helps with manually triggering cmp
----------
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Sources for General Cmp
----------
local general_sources = {
    { name = cmpsnip },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "treesitter" },
    { name = "cmdline" },
}

-- Cmp-Ui
----------
local cmp_formatting = {
    format = function(entry, vim_item)
        if vim.tbl_contains({ "path" }, entry.source.name) then
            local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
            if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
            end
        end
        return lspkind.cmp_format({ with_text = false })(entry, vim_item)
    end,
}
----------

-- Combine Snips and Cmp into same mappings
----------
-- Next Selection
local snip_cmp_next = cmp.mapping(function(fallback)
    if snip.jumpable(1) then
        snip.jump(1)
    elseif cmp.visible() then
        cmp.select_next_item()
    elseif has_words_before() then
        cmp.complete()
    else
        fallback()
    end
end, { "i", "s", "c" })
-- Previous Selection
local snip_cmp_previous = cmp.mapping(function(fallback)
    if snip.jumpable(-1) then
        snip.jump(-1)
    elseif cmp.visible() then
        cmp.select_prev_item()
    else
        fallback()
    end
end, { "i", "s", "c" })

local cmp_abort = cmp.mapping(function(fallback)
    if cmp.visible() then
        cmp.abort()
    else
        fallback()
    end
end, { "i", "s", "c" })
-- Confirm Selection
local cmp_select = cmp.mapping(function(fallback)
    if cmp.visible() and has_words_before() and cmp.get_active_entry() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
    elseif snip.expandable() and has_words_before and cmp.get_active_entry() then
        snip.expand_or_jump()
    else
        fallback()
    end
end, { "i" })
-- In command modes use TAB for cmp selection
local cmd_cmp_select = cmp.mapping(function()
    if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
    else
        cmp.complete()
    end
end, { "c" })
-- Toggle Cmp window on and off
local cmp_toggle = cmp.mapping(function()
    if cmp.visible() then
        cmp.close()
    else
        cmp.complete()
    end
end, { "i", "s" })
----------

-- Setup - General
----------
cmp.setup({
    enabled = { general_enabled },
    sources = general_sources,
    completion = { completeopt = "menu,menuone,noinsert,noselect", keyword_length = 1 },
    snippet = {
        expand = function(args)
            snip.lsp_expand(args.body)
        end,
    },
    -- Making autocomplete menu look nice
    formatting = cmp_formatting,
    mapping = {
        ["<C-l>"] = snip_cmp_next,
        ["<C-h>"] = snip_cmp_previous,
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<Esc>"] = cmp_abort,
        ["<CR>"] = cmp_select,
        ["<c-space>"] = cmp_toggle, -- toggle completion suggestions
    },
    window = {
        completion = cmp.config.window.bordered({
            border = "rounded",
        }),
        documentation = cmp.config.window.bordered({
            border = "rounded",
        }),
    },
})

----------

-- Setup - Text Search '/'
----------
cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
    mapping = {
        ["<TAB>"] = cmd_cmp_select,
    },
})
----------

-- Setup - Commandline ':'
----------
cmp.setup.cmdline(":", {
    sources = {
        { name = "cmdline" },
        { name = "path" },
    },
    mapping = {
        ["<TAB>"] = cmd_cmp_select,
    },
})
----------

-- Git Commit Setup
----------
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = "buffer" },
    }),
})
----------

-- Add Cmp Capabilities
----------
local capabilities = cmp_lsp.default_capabilities(lsp.protocol.make_client_capabilities())
----------

--------------------------------
-- Language Server Key Mappings
--------------------------------

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

-- Mappings
----------
local function keymappings(client)
    -- Mapping Opts
    ----------
    -- Silent Mappings
    local function bufopts(opts)
        local standardOpts = { noremap = true, silent = true, buffer = 0 }
        for k, v in pairs(standardOpts) do
            opts[k] = v
        end
        return opts
    end
    -- Non silent Mappings
    local function loudbufopts(opts)
        local standardOpts = { noremap = true, silent = false, buffer = 0 }
        for k, v in pairs(standardOpts) do
            opts[k] = v
        end
        return opts
    end

    b["max_line_length"] = 0 -- This has to be attached to the buffer so I went for a bufferopt

    -- Mappings
    ----------
    -- Commands that keep you in this buffer `g`
    keymap.set("n", "gw", ":lua vim.diagnostic.open_float()<CR>", bufopts({ desc = "LSP: Open Diagnostics Window" }))
    keymap.set(
        "n",
        "gW",
        ":lua require('telescope.builtin').diagnostics()<CR>",
        bufopts({ desc = "LSP: List All Diagnostics" })
    )
    keymap.set(
        "n",
        "gs",
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        bufopts({ desc = "LSP: Bring Up LSP Explanation" })
    )
    keymap.set("n", "g=", ":lua vim.lsp.buf.code_action()<CR>", bufopts({ desc = "LSP: Take Code Action" }))
    keymap.set("n", "gh", ":lua vim.lsp.buf.hover()<CR>", bufopts({ desc = "LSP: Open Hover Dialog" }))
    keymap.set("n", "gl", ":lua ShortenLine()<CR>", bufopts({ desc = "LSP: Shorten Line" }))
    keymap.set("n", "gf", ":lua FormatWithConfirm()<CR>", loudbufopts({ desc = "LSP: Format Code" }))
    keymap.set("n", "[g", ":lua vim.diagnostic.goto_prev()<CR>", bufopts({ desc = "LSP: Previous Flag" }))
    keymap.set("n", "]g", ":lua vim.diagnostic.goto_next()<CR>", bufopts({ desc = "LSP: Next Flag" }))
    keymap.set(
        "n",
        "[G",
        ":lua vim.diagnostic.goto_prev({severity = diagnostic.severity.ERROR})<CR>",
        bufopts({ desc = "LSP: Next Error" })
    )
    keymap.set(
        "n",
        "]G",
        ":lua vim.diagnostic.goto_next({severity = diagnostic.severity.ERROR})<CR>",
        bufopts({ desc = "LSP: Previous Error" })
    )
    -- Commands where you leave current buffer `<leader>c`
    keymap.set(
        "n",
        "<leader>cR",
        "<cmd>lua vim.lsp.buf.rename()<CR>",
        bufopts({ desc = "LSP: Rename Item Under Cursor" })
    )
    keymap.set("n", "<leader>cI", "<cmd>LspInfo<CR>", bufopts({ desc = "LSP: Show Info" }))
    -- Need something here that says (if implementation isn't supported open definition/declaration in new buffer
    keymap.set("n", "<leader>cD", "<Cmd>lua vim.lsp.buf.definition()<CR>", bufopts({ desc = "LSP: Go To Definition" }))
    keymap.set(
        "n",
        "<leader>cd",
        "<Cmd>lua vim.lsp.buf.declaration()<CR>",
        bufopts({ desc = "LSP: Go To Declaration" })
    )
    keymap.set(
        "n",
        "<leader>cr",
        "<cmd>lua require('telescope.builtin').lsp_references()<CR>",
        bufopts({ desc = "LSP: Go to References" })
    )
    keymap.set(
        "n",
        "<leader>ci",
        "<cmd>lua vim.lsp.buf.implementation()<CR>",
        bufopts({ desc = "LSP: Go To Implementation" })
    )
    keymap.set(
        "n",
        "<leader>ct",
        "<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>",
        bufopts({ desc = "LSP: Go To Type Definition" })
    )
    -- Mapping Assistance
    ----------
    whichKey.register({
        g = { name = "Code & Diagnostics Actions" },
    })
    ----------
end

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
    api.nvim_buf_set_option(0, "formatexpr", "v:lua.require'conform'.formatexpr()")
    -- Attach Keymappings
    keymappings(client)
end

----------

--------------------------------
-- Setup of Language Servers
--------------------------------

-- Functions
----------
-- Find Python Virutal_Env
local function get_python_path()
    -- Use Activated Environment
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    end
    -- Fallback to System Python
    return fn.exepath("python3") or fn.exepath("python") or "python"
end

-- Lua: Language Server
----------
config.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    -- Config
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } }, -- Makes sure that vim, packer global errors dont pop up
            workspace = {
                library = api.nvim_get_runtime_file("", true),
                checkThirdParty = false, -- Stops annoying config prompts
            },
            completion = { autoRequire = false },
            telemetry = { enable = false }, -- Don't steal my data
        },
    },
})
----------

-- Python: Pyright
----------
config.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    on_init = function(client)
        client.config.settings.python.pythonPath = get_python_path()
    end,
})
----------

-- Web
----------
-- TSServer
config.tsserver.setup({
    capabilities = require("cmp_nvim_lsp").default_capabilities(lsp.protocol.make_client_capabilities()),
    on_attach = function(client)
        client.server_capabilities.document_formatting = false
    end,
})
-- Emmet Integration
config.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
-- cssls
config.cssls.setup({ on_attach = on_attach, capabilities = capabilities })
-- Svelte Setup
config.svelte.setup({ on_attach = on_attach, capabilities = capabilities })
----------

-- Json
----------
config.jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        provideFormatter = true,
    },
})
----------

-- Cucumber
----------
config.cucumber_language_server.setup({ on_attach = on_attach, capabilities = capabilities })
----------

-- Bash
----------
config.bashls.setup({ on_attach = on_attach, capabilities = capabilities })
----------

-- Yaml
----------
config.yamlls.setup({ on_attach = on_attach, capabilities = capabilities })
----------

-- SQL
----------
config.sqlls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = config.util.root_pattern("*.sql"),
})
----------

-- Rust Server
----------
config.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
        },
    },
})
----------

-- Terraform
---------
config.terraformls.setup({ on_attach = on_attach, capabilities = capabilities, filetypes = { "tf", "terraform" } })
config.tflint.setup({ on_attach = on_attach, capabilities = capabilities })

--------------------------------
-- Setup of Null-ls -- Third Party LSPs
--------------------------------

-- Import Null-ls
----------
local nullls = require("null-ls")
local format = nullls.builtins.formatting    -- Formatting
local diagnose = nullls.builtins.diagnostics -- Diagnostics
local code_actions = nullls.builtins.code_actions
local hover = nullls.builtins.hover
local completion = nullls.builtins.completion -- Code Completion
----------

-- Variables
----------
-- Builtin
local nullSources = {}
----------

----------

-- Setup Various Servers/Packages
----------
-- Installed Mason Managed Sources (I prefer these because they'll sit with everything else)
local mason_installed = require("mason-registry")
for _, package in pairs(mason_installed.get_installed_package_names()) do
    -- Shell
    ----------
    -- Shellcheck
    if package == "shellcheck" then
        nullSources[#nullSources + 1] = code_actions.shellcheck.with({ on_attach = on_attach })
        nullSources[#nullSources + 1] = diagnose.shellcheck.with({ on_attach = on_attach })
    end
    -- Shellharden
    if package == "shellharden" then
        nullSources[#nullSources + 1] = format.shellharden.with({ on_attach = on_attach })
    end
    -- Yaml
    ----------
    if package == "yamllint" then
        nullSources[#nullSources + 1] = diagnose.yamllint.with({ on_attach = on_attach })
    end
    -- Web Dev
    ----------
    -- Eslint
    if package == "eslint-lsp" then
        local eslint_file_types = { "javascript", "typescript", "html", "graphql", "svelte" }
        nullSources[#nullSources + 1] = code_actions.eslint.with({
            on_attach = on_attach,
            filetypes = eslint_file_types,
        })
        nullSources[#nullSources + 1] = diagnose.eslint.with({
            on_attach = on_attach,
            filetypes = eslint_file_types,
        })
        nullSources[#nullSources + 1] = format.eslint.with({
            on_attach = on_attach,
            filetypes = eslint_file_types,
        })
    end
    -- Prettier
    if package == "prettier" then
        local prettier_file_types =
        { "javascript", "vue", "css", "scss", "less", "html", "yaml", "graphql", "handlebars" }
        nullSources[#nullSources + 1] = format.prettier.with({
            on_attach = on_attach,
            filetypes = prettier_file_types,
        })
    end
    ----------
    -- Restructured Text
    if package == "rstcheck" then
        nullSources[#nullSources + 1] = diagnose.rstcheck.with({
            on_attach = on_attach,
            filetypes = { "rst" },
        })
    end
    -- English
    ----------
    if package == "write-good" then
        nullSources[#nullSources + 1] = diagnose.write_good.with({
            on_attach = on_attach,
            filetypes = {
                "txt",
                "md",
                "mdx",
                "markdown",
            },
            diagnostics_postprocess = function(diagnostic)
                diagnostic.severity = vim.diagnostic.severity["INFO"]
            end,
        })
    end
    if package == "proselint" then
        nullSources[#nullSources + 1] = diagnose.proselint.with({
            on_attach = on_attach,
            filetypes = {
                "txt",
                "md",
                "mdx",
                "markdown",
            },
        })
        nullSources[#nullSources + 1] = code_actions.proselint.with({
            on_attach = on_attach,
            filetypes = {
                "txt",
                "md",
                "mdx",
                "markdown",
            },
        })
    end
end
------------

-- Builtin Sources (Not Managed By Mason)
----------
-- English Completion
nullSources[#nullSources + 1] = completion.spell.with({
    on_attach = on_attach,
    autostart = true,
    filetypes = { "txt", "markdown", "md", "mdx" },
})
-- -- Dictionary Definitions
nullSources[#nullSources + 1] = hover.dictionary.with({
    on_attach = on_attach,
    autostart = true,
    filetypes = { "txt", "markdown", "md", "mdx" },
})
-----------

-- Load the Packages into the Null-ls engine
----------
nullls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    debug = true,
    sources = { sources = nullSources },
})
----------

--------------------------------
-- Colors and Themes
--------------------------------

hl(0, "LspDiagnosticsUnderlineError", { bg = "#EB4917", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineWarning", { bg = "#EBA217", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineInformation", { bg = "#17D6EB", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineHint", { bg = "#17EB7A", underline = true, blend = 50 })

--------------------------------
-- Debug Adapter Protocol
--------------------------------

-- Helper Funcs
----------
local python_path = get_python_path()

-- Mappings
----------

local function keyopts(opts)
    local standardOpts = { silent = false, noremap = true }
    for k, v in pairs(standardOpts) do
        opts[k] = v
    end
    return opts
end
-- Session Commands
keymap.set("n", "<leader>bs", "<cmd>lua require('dap').session()<cr>", keyopts({ desc = "Start Debug Session" }))
keymap.set("n", "<leader>bc", "<cmd>lua require('dap').continue()<cr>", keyopts({ desc = "Continue Debug Run" }))       -- bug continue
keymap.set("n", "<leader>bx", "<cmd>lua require('dap').disconnect()<cr>", keyopts({ desc = "Deattach Debug Session" })) -- bug exit
keymap.set("n", "<leader>bq", "<cmd>lua require('dap').close()<cr>", keyopts({ desc = "Close Debug Session" }))
keymap.set("n", "<leader>bQ", "<cmd>lua require('dap').terminate()<cr>", keyopts({ desc = "Terminate Debug Session" }))
-- Breakpoints (and pauses)
keymap.set(
    "n",
    "<leader>bb",
    "<cmd>lua require('dap').toggle_breakpoint()<cr>",
    keyopts({ desc = "Toggle Breakpoint" })
)
keymap.set(
    "n",
    "<leader>bB",
    "<cmd>lua require('dap').set_breakpoint(vim.fn.input '[Condition] > ')<cr>",
    keyopts({ desc = "Set Conditional BreakPoint" })
) -- bug breakpoint
keymap.set("n", "<leader>bS", "<cmd>lua require('dap').set_breakpoint()<cr>", keyopts({ desc = "Set Breakpoint" }))
keymap.set("n", "<leader>bp", "<cmd>lua require('dap').pause.toggle()<cr>", keyopts({ desc = "Toggle Pause" }))
-- Stepping commands
keymap.set(
    "n",
    "<leader>bC",
    "<cmd>lua require('dap').run_to_cursor()<cr>",
    keyopts({ desc = "Run Session To Cursor" })
)                                                                                                         -- run to here
keymap.set("n", "<leader>bk", "<cmd>lua require('dap').step_back()<cr>", keyopts({ desc = "Step Back" })) -- bug previous
keymap.set("n", "<leader>bl", "<cmd>lua require('dap').step_into()<cr>", keyopts({ desc = "Step Into" }))
keymap.set("n", "<leader>bj", "<cmd>lua require('dap').step_over()<cr>", keyopts({ desc = "Step Over" }))
keymap.set("n", "<leader>bh", "<cmd>lua require('dap').step_out()<cr>", keyopts({ desc = "Step Out" }))
-- Dap REPL
keymap.set("n", "<leader>br", "<cmd>lua require('dap').repl.toggle()<cr>", keyopts({ desc = "Toggle Debug REPL" }))
----------

-- Telescope Integration
----------

-- Adding Assistance Menus
whichKey.register({
    ["<leader>"] = {
        b = {
            f = { name = "UI Options" },
            w = { name = "Language Options" },
        },
    },
})

-- telescope-dap loaded in init.lua
keymap.set(
    "n",
    "<leader>bfc",
    '<cmd>lua require"telescope".extensions.dap.commands{}<CR>',
    keyopts({ desc = "Debug Command Palette UI" })
)
keymap.set(
    "n",
    "<leader>bfo",
    '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>',
    keyopts({ desc = "Debug Config UI" })
)
keymap.set(
    "n",
    "<leader>bfb",
    '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>',
    keyopts({ desc = "List All BreakPoints UI" })
)
keymap.set(
    "n",
    "<leader>bfv",
    '<cmd>lua require"telescope".extensions.dap.variables{}<CR>',
    keyopts({ desc = "Variable UI" })
)
keymap.set(
    "n",
    "<leader>bff",
    '<cmd>lua require"telescope".extensions.dap.frames{}<CR>',
    keyopts({ desc = "Frames UI" })
)

----------

-- UI Integration
----------

-- Setup
dapui.setup({
    layouts = {
        {
            elements = {
                {
                    id = "scopes",
                    size = 0.5,
                },
                {
                    id = "breakpoints",
                    size = 0.5,
                },
            },
            position = "left",
            size = 40,
        },
    },
})
-- Auto-open
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
----------

-- Adapter Selection
----------

-- Python
dap.adapters.python = {
    type = "executable",
    command = python_path,
    args = { "-m", "debugpy.adapter" },
}

----------

-- Adapter Configuration
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
    },
}

----------

-------------------------------
-- EOF
-------------------------------
