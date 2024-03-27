--------------------------
-- ###################  --
-- # Lsp Vim Config  #  --
-- ###################  --
--------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
-- Api Exposures
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local fs = vim.fs -- vim filesystem
local keymap = vim.keymap -- keymaps
local lsp = vim.lsp -- Lsp inbuilt
local log = vim.log
-- Options
local bo = vim.bo -- bufferopts
-- For Variables
local b = vim.b -- buffer variables
G = vim.g -- global variables
local hl = api.nvim_set_hl -- highlighting
--------

-- Requires
----------
local config = require("lspconfig") -- Overall configuration for lsp
local tool_manager = require("mason")
local tool_installer = require("mason-tool-installer")
local cmp = require("cmp") -- Autocompletion for the language servers
local cmp_lsp = require("cmp_nvim_lsp")
local dap = require("dap")
local daptext = require("nvim-dap-virtual-text")
local lint = require("lint")
local format = require("conform")
local snip = require("luasnip")
local snipload_lua = require("luasnip.loaders.from_lua")
local snipload_vscode = require("luasnip.loaders.from_vscode")
local lspkind = require("lspkind")
local dappy = require("dap-python")
local putils = require("personal_utils")
local lm = require("leader_mappings")
----------

-- Extra Vars
----------
local keyopts = putils.keyopts
local nmap = putils.norm_keyset
local tableConcat = putils.tableConcat
local scandir_menu = putils.scandirMenu
local get_venv_command = putils.get_venv_command
local file_exists = putils.fileExists
local get_python_path = putils.get_python_path
----------

-- Compressing Text w/Vars
----------
local lreq = "lua require"
----------

--------------------------------
-- Installer and Package Management
--------------------------------

-- Dependent Modules Require
----------
local tool_dir = os.getenv("HOME") .. "/.config/nvim/lua/lsp_servers"
tool_manager.setup({
	install_root_dir = tool_dir,
}) -- Mason is the engine the installer configs will run
----------

-- Package Installs
----------
-- Core Language Servers
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
}
-- Formatters
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
local debuggers_ei = { "debugpy", "bash-debug-adapter", "codelldb", "go-debug-adapter" }
----------

-- Install Packages
----------
tool_installer.setup({
	ensure_installed = tableConcat(formatters_ei, tableConcat(linters_ei, tableConcat(debuggers_ei, lsp_servers_ei))),
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

-- Mappings
----------
keymap.set({ "i", "s" }, "<C-J>", function()
	snip.expand()
end, { silent = true })
keymap.set({ "i", "s" }, "<C-L>", function()
	snip.jump(1)
end, { silent = true })
keymap.set({ "i", "s" }, "<C-H>", function()
	snip.jump(-1)
end, { silent = true })
keymap.set({ "i", "s" }, "<C-E>", function()
	if snip.choice_active() then
		snip.change_choice(1)
	end
end, { silent = true })
----------

--------------------------------
-- Setup of Formatters - formatter.nvim
--------------------------------

-- Setup
----------
format.setup({
	-- Log Levels in Formatter
	log_level = log.levels.TRACE,
	-- Formatter Choice
	formatters_by_ft = {
		python = { "black", "isort", "injected" },
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier", "injected" },
		sh = { "shellharden" },
		json = { "jq", "jsonls" },
		markdown = { "markdownlint" },
		yaml = { "yamlfmt" },
		sql = { "sql_formatter" },
		rust = { "rustfmt" },
		jinja = { "djlint" },
		tex = { "latex-indent" },
		go = { "gofumpt" },
	},
})
-- Setup for injected languages
format.formatters.injected = {
	options = {
		ignore_errors = false,
		lang_to_ext = {
			bash = "sh",
			latex = "tex",
			markdown = "md",
			html = "html",
			sql = "sql",
			python = "py",
			r = "r",
			typescript = "ts",
		},
	},
}

-- General Format Function
----------
function FormatWithConfirm()
	format.format({ async = true, lsp_fallback = true })
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
	markdown = { "markdownlint", "proselint", "write_good" },
	yaml = { "yamllint" },
	html = { "htmlhint" },
	css = { "stylelint" },
	sh = { "shellcheck" },
	jinja = { "djlint" },
	solidity = { "solhint" },
	go = { "golangcilint" },
}

-- Auto-Lint on Save, Enter, and InsertLeave
api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufWinEnter", "BufEnter" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- Mappings
----------
api.nvim_create_user_command("Relint", function()
	require("lint").try_lint()
end, {})
nmap("gl", "Relint", "Refresh Linter")
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
-- Completion
--------------------------------

-- Support Functions
----------
-- Enablement for General Setup
local general_enabled = function()
	local context = require("cmp.config.context") -- disable completion in comments
	if vim.api.nvim_get_mode().mode == "c" then -- keep command mode completion enabled when cursor is in a comment
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
	{ name = "luasnip" },
	{ name = "nvim_lsp" },
	{ name = "nvim_lsp_document_symbol" },
	{ name = "htmx" },
	{ name = "otter" },
	{ name = "path" },
	{ name = "buffer" },
	{ name = "nvim_lua" },
	{ name = "spell" },
	{ name = "treesitter" },
	{ name = "dotenv" },
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
	if cmp.visible() then
		cmp.select_next_item()
	elseif has_words_before() then
		cmp.complete()
	else
		fallback()
	end
end, { "i", "s", "c" })
-- Previous Selection
local snip_cmp_previous = cmp.mapping(function(fallback)
	if cmp.visible() then
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
		{ name = "cmdline_history" },
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
	b["max_line_length"] = 0 -- This has to be attached to the buffer so I went for a bufferopt

	-- Mappings
	----------
	-- Commands that keep you in this buffer `g`
	nmap("gw", "lua vim.diagnostic.open_float()", "LSP: Open Diagnostics Window")
	nmap("g=", "lua vim.lsp.buf.code_action()", "LSP: Take Code Action")
	nmap("gi", "lua vim.lsp.buf.hover()", "LSP: Function & Library Info")
	nmap("gL", "lua ShortenLine()", "LSP: Shorten Line")
	nmap("gf", "lua FormatWithConfirm()", "LSP: Format Code")
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
	nmap(lm.codeAction .. "r", "lua require('telescope.builtin').lsp_references()", "LSP: Go to References")
	nmap(lm.codeAction .. "i", "lua vim.lsp.buf.implementation()", "LSP: Go To Implementation")
	nmap(lm.codeAction .. "t", "lua require('telescope.builtin').lsp_type_definitions()", "LSP: Go To Type Definition")
	nmap(lm.codeAction .. "p", "lua require('telescope.builtin').diagnostics()", "Show all Diagnostics")
	nmap(
		lm.codeAction_symbols .. "w",
		lreq .. "('telescope.builtin').lsp_workspace_symbols()",
		"Show Workspace Symbols"
	)
	nmap(lm.codeAction_symbols .. "d", lreq .. "('telescope.builtin').lsp_document_symbols()", "Show Document Symbols")
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

-- Functions
----------
-- Standard Opts
local function lsp_opts(opts)
	local standardOpts = {
		on_attach = on_attach,
		capabilities = capabilities,
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

-- Injected Languages (Otter)
----------
OtterStart = function()
	local otter = require("otter")
	local filetype = bo.filetype
	if filetype == "python" then
		otter.activate({ "htmldjango", "html", "sql" })
	end
	nmap(lm.codeAction_injectedLanguage .. "d", lreq .. '"otter".ask_definition()', "Show Definition")
	nmap(lm.codeAction_injectedLanguage .. "t", lreq .. '"otter".ask_type_definition()', "Show Type Definition")
	nmap(lm.codeAction_injectedLanguage .. "I", lreq .. '"otter".ask_hover()', "Show Info")
	nmap(lm.codeAction_injectedLanguage .. "s", lreq .. '"otter".ask_document_symbols()', "Show Symbols")
	nmap(lm.codeAction_injectedLanguage .. "R", lreq .. '"otter".ask_rename()', "Rename")
	nmap(lm.codeAction_injectedLanguage .. "f", lreq .. '"otter".ask_format()', "Format")
end

api.nvim_create_user_command("OtterActivate", OtterStart, {})
----------

-- Null-ls : Third Party LSPs
----------
-- Import Null-ls
local nullls = require("null-ls")
local hover = nullls.builtins.hover
local completion = nullls.builtins.completion -- Code Completion
-- Variables
local nullSources = {}
-- English Completion
-- TASK: Recreate this with LspConfig, under the hood it uses vim.fn.spellsuggest
nullSources[#nullSources + 1] = completion.spell.with({
	on_attach = on_attach,
	autostart = true,
	filetypes = { "txt", "markdown", "md", "mdx", "tex", "yaml" },
})
-- Dictionary Definitions
-- TASK: Recreate this with LspConfig, under the hood it uses a call to dictionary.api website
nullSources[#nullSources + 1] = hover.dictionary.with({
	on_attach = on_attach,
	autostart = true,
	filetypes = { "txt", "markdown", "md", "mdx" },
})
-- Package Load
nullls.setup(lsp_opts({ debug = true, sources = { sources = nullSources } }))
----------

--------------------------------
-- Debug Adapter Protocol
--------------------------------

-- Helper Funcs
----------
local python_path = get_python_path()

-- Colors and Themes
----------
-- Colors
hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#cc3939", bg = "#31353f" })
hl(0, "DapBreakpointCondition", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })
-- Symbols
fn.sign_define(
	"DapBreakpoint",
	{ text = "󰃤", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
fn.sign_define("DapBreakpointCondition", {
	text = "󱏛",
	texthl = "DapBreakpointCondition",
	linehl = "DapBreakpointCondition",
	numhl = "DapBreakpointCondition",
})
fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
----------

----------
-- Mappings
----------

-- Running Commands (and pauses)
----------
nmap(lm.debug .. "c", lreq .. "('dap').continue()", "Continue/Start Debug Run")
nmap(lm.debug .. "b", lreq .. "('dap').toggle_breakpoint()", "Toggle Breakpoint")
nmap(lm.debug .. "B", lreq .. "('dap').set_breakpoint(vim.fn.input '[Condition] > ')", "Set Conditional BreakPoint")
nmap(lm.debug .. "p", lreq .. "('dap').pause.toggle()", "Toggle Pause")
nmap(lm.debug .. "r", lreq .. "('dap').restart()", "Restart Debugger")
nmap(lm.debug .. "C", lreq .. "('dap').run_to_cursor()", "Run Session To Cursor")
----------

-- Stepping Commands
------------
nmap(lm.debug .. "h", lreq .. "('dap').step_back()", "Step Back")
nmap(lm.debug .. "k", lreq .. "('dap').step_into()", "Step Into")
nmap(lm.debug .. "l", lreq .. "('dap').step_over()", "Step Over")
nmap(lm.debug .. "j", lreq .. "('dap').step_out()", "Step Out")
nmap(lm.debug .. "K", lreq .. "('dap').up()", "Step Up Call Stack")
nmap(lm.debug .. "J", lreq .. "('dap').down()", "Step Down Call Stack")
------------

-- Dap REPL
------------
nmap(lm.debug .. "x", lreq .. "('dap').repl.toggle()", "Debug REPL Toggle")
------------

-- Session Commands
------------
nmap(lm.debug_session .. "s", lreq .. "('dap').session()", "Start Debug Session")
nmap(lm.debug_session .. "c", lreq .. "('dap').close()", "Close Debug Session")
nmap(lm.debug_session .. "a", lreq .. "('dap').attach()", "Attach Debug Session")
nmap(lm.debug_session .. "d", lreq .. "('dap').disconnect()", "Detach Debug Session")
nmap(lm.debug .. "q", lreq .. "('dap').terminate()", "Quit Debug Session")
----------

-- UI Commands
----------
local duw = 'require("dap.ui.widgets")'
nmap(lm.debug .. "v", "lua " .. duw .. ".hover()", "Variable Info")
nmap(lm.debug .. "S", "lua " .. duw .. ".cursor_float(" .. duw .. ".scopes)", "Scope Info")
nmap(lm.debug .. "F", "lua " .. duw .. ".cursor_float(" .. duw .. ".frames)", "Stack Frame Info")
nmap(lm.debug .. "e", "lua " .. duw .. ".cursor_float(" .. duw .. ".expressions)", "Expression Info")
----------

-- Telescope Commands
----------
nmap(lm.debug_fileView .. "c", lreq .. '"telescope".extensions.dap.commands{}', "Show Debug Command Palette")
nmap(lm.debug_fileView .. "o", lreq .. '"telescope".extensions.dap.configurations{}', "Show Debug Options")
nmap(lm.debug_fileView .. "b", lreq .. '"telescope".extensions.dap.list_breakpoints{}', "Show All BreakPoints")
nmap(lm.debug_fileView .. "v", lreq .. '"telescope".extensions.dap.variables{}', "Show All Variables")
nmap(lm.debug_fileView .. "f", lreq .. '"telescope".extensions.dap.frames{}', "Show All Frames")
----------

-- Language Specific Commands
----------
nmap(lm.debug_python .. "m", lreq .. "('dap-python').test_method()", "Test Method")
nmap(lm.debug_python .. "c", lreq .. "('dap-python').test_class()", "Test Class")
nmap(lm.debug_python .. "s", lreq .. "('dap-python').debug_selection()", "Debug Selected")
----------

----------
-- DAP Setup
----------

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

--------------------------------
-- Virtual Text DAP
--------------------------------

daptext.setup()

----------

-------------------------------
-- EOF
-------------------------------
