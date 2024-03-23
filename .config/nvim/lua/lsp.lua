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
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local fs = vim.fs -- vim filesystem
local ft = vim.filetype
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

-- Required Module Loading Core Lsp Stuff
----------
local config = require("lspconfig") -- Overall configuration for lsp
local tool_manager = require("mason")
local tool_installer = require("mason-tool-installer")
local tool_installed_packages = require("mason-registry")
local cmp = require("cmp") -- Autocompletion for the language servers
local cmp_lsp = require("cmp_nvim_lsp")
local dap = require("dap")
local daptext = require("nvim-dap-virtual-text")
local lint = require("lint")
local format = require("conform")
local snip = require("luasnip")
local snipload_lua = require("luasnip.loaders.from_lua")
local snipload_vscode = require("luasnip.loaders.from_vscode")
local whichKey = require("which-key")
local ui_menu = require("nui.menu")
--------

-- Required Extras
----------
local path = config.util.path
local cmpsnip = require("cmp_luasnip")
local cmphtmx = require("cmp-htmx")
local cmplua = require("cmp_nvim_lua")
local telescope = require("telescope")
local lspkind = require("lspkind")
local dap_widgets = require("dap.ui.widgets")
local dappy = require("dap-python")
local otter = require("otter")
----------

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

-- Apply standard options for keymaps
----------
local function keyopts(opts)
	local standardOpts = { silent = false, noremap = true }
	for k, v in pairs(standardOpts) do
		opts[k] = v
	end
	return opts
end
----------

-- Get a folders files as members of a table
----------
local function scandir_menu(title, dir, sub_func)
	local scan = require("plenary.scandir")
	local Menu = require("nui.menu")
	local scan_results = scan.scan_dir(dir, { hidden = false })
	local menu_lines = { Menu.separator("Sep1") }
	for _, v in pairs(scan_results) do
		local item = Menu.item(v)
		table.insert(menu_lines, item)
	end
	local dir_menu = Menu({
		position = "50%",
		border = {
			style = "single",
			text = {
				top = "[ " .. title .. " ]",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		lines = menu_lines,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_close = function()
			print("Closed Menu, operation cancelled")
		end,
		on_submit = function(item)
			sub_func(item.text)
		end,
	})
	return dir_menu
end

----------

-- On Exit for Sys Calls
----------
local on_exit = function(obj)
	print(obj.code)
	print(obj.signal)
	print(obj.stdout)
	print(obj.stderr)
end
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
}
-- Debuggers
local debuggers_ei = { "debugpy", "bash-debug-adapter", "codelldb" }
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
	},
})

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
keymap.set("n", "gl", ":Relint<CR>", keyopts({ desc = "Refresh Linter" }))
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
	{ name = "otter" },
	{ name = "path" },
	{ name = "buffer" },
	{ name = "nvim_lua" },
	{ name = "spell" },
	{ name = "htmx" },
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
		"gh",
		"<cmd>lua vim.lsp.buf.signature_help()<CR>",
		bufopts({ desc = "LSP: Bring Up LSP Explanation" })
	)
	keymap.set(
		"n",
		"gs",
		":lua require('telescope.builtin').lsp_document_symbols()<CR>",
		bufopts({ desc = "LSP: Get Current Buffer Symbols" })
	)
	keymap.set("n", "g=", ":lua vim.lsp.buf.code_action()<CR>", bufopts({ desc = "LSP: Take Code Action" }))
	keymap.set("n", "gi", ":lua vim.lsp.buf.hover()<CR>", bufopts({ desc = "LSP: Function & Library Info" }))
	keymap.set("n", "gL", ":lua ShortenLine()<CR>", bufopts({ desc = "LSP: Shorten Line" }))
	keymap.set("n", "gf", ":lua FormatWithConfirm()<CR>", loudbufopts({ desc = "LSP: Format Code" }))
	keymap.set("n", "[g", ":lua vim.diagnostic.goto_prev()<CR>", bufopts({ desc = "LSP: Previous Flag" }))
	keymap.set("n", "]g", ":lua vim.diagnostic.goto_next()<CR>", bufopts({ desc = "LSP: Next Flag" }))
	keymap.set(
		"n",
		"[G",
		":lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>",
		bufopts({ desc = "LSP: Next Error" })
	)
	keymap.set(
		"n",
		"]G",
		":lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>",
		bufopts({ desc = "LSP: Previous Error" })
	)
	keymap.set("n", "gr", ":LSPRestart<CR>", bufopts({ desc = "LSP: Previous Error" }))
	-- Commands where you leave current buffer `<leader>c`
	keymap.set(
		"n",
		"<leader>cR",
		"<cmd>lua vim.lsp.buf.rename()<CR>",
		bufopts({ desc = "LSP: Rename Item Under Cursor" })
	)
	keymap.set("n", "<leader>cI", "<cmd>LspInfo<CR>", bufopts({ desc = "LSP: Show Info" }))
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
	keymap.set(
		"n",
		"<leader>cp",
		"<cmd>lua require('telescope.builtin').diagnostics()<CR>",
		bufopts({ desc = "Show all Diagnostics" })
	)
	keymap.set(
		"n",
		"<leader>csw",
		"<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>",
		bufopts({ desc = "Show Workspace Symbols" })
	)
	keymap.set(
		"n",
		"<leader>csd",
		"<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>",
		bufopts({ desc = "Show Document Symbols" })
	)
	-- Mapping Assistance
	----------
	whichKey.register({
		g = { name = "Code & Diagnostics Actions" },
		["<leader>"] = {
			c = {
				name = "Code & Diagnoctic Actions",
				s = { name = "Language Server Symbol Options" },
				l = { name = "Injected Language Options" },
			},
		},
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

-- Functions
----------
-- Find Python Virutal_Env
function get_python_path()
	-- Use Activated Environment
	if vim.env.VIRTUAL_ENV then
		return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
	end
	-- Fallback to System Python
	return fn.exepath("python3") or fn.exepath("python") or "python"
end
-- Standard Opts
local function lsp_opts(opts)
	local standardOpts = { on_attach = on_attach, capabilities = capabilities }
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
			diagnostics = { globals = { "vim" } }, -- Makes sure that vim, packer global errors dont pop up
			workspace = {
				library = api.nvim_get_runtime_file("", true),
				checkThirdParty = false, -- Stops annoying config prompts
			},
			completion = { autoRequire = false },
			telemetry = { enable = false }, -- Don't steal my data
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

-- Injected Languages (Otter)
----------
api.nvim_create_user_command("OtterActivate", function()
	local otter = require("otter")
	local filetype = vim.bo.filetype
	if filetype == "python" then
		otter.activate({ "htmldjango", "html", "sql" })
	end
	vim.keymap.set(
		"n",
		"<leader>cld",
		':lua require"otter".ask_definition()<cr>',
		keyopts({ desc = "Show Definition" })
	)
	vim.keymap.set(
		"n",
		"<leader>clt",
		':lua require"otter".ask_type_definition()<cr>',
		keyopts({ desc = "Show Type Definition" })
	)
	vim.keymap.set("n", "<leader>clI", ':lua require"otter".ask_hover()<cr>', keyopts({ desc = "Show Info" }))
	vim.keymap.set(
		"n",
		"<leader>cls",
		':lua require"otter".ask_document_symbols()<cr>',
		keyopts({ desc = "Show Symbols" })
	)
	vim.keymap.set("n", "<leader>clR", ':lua require"otter".ask_rename()<cr>', keyopts({ desc = "Rename" }))
	vim.keymap.set("n", "<leader>clf", ':lua require"otter".ask_format()<cr>', keyopts({ desc = "Format" }))
end, {})
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

-- Colors and Themes
----------
hl(0, "LspDiagnosticsUnderlineError", { bg = "#EB4917", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineWarning", { bg = "#EBA217", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineInformation", { bg = "#17D6EB", underline = true, blend = 50 })
hl(0, "LspDiagnosticsUnderlineHint", { bg = "#17EB7A", underline = true, blend = 50 })
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

-- Assistance Menus
----------
whichKey.register({
	["<leader>"] = {
		b = {
			f = { name = "Debug Widgets" },
			s = { name = "Session Commands" },
			w = { name = "Language Options" },
			P = { name = "Python Debug" },
		},
	},
})
----------

-- Running Commands (and pauses)
----------
keymap.set("n", "<leader>bc", "<cmd>lua require('dap').continue()<cr>", keyopts({ desc = "Continue/Start Debug Run" }))
keymap.set(
	{ "n" },
	"<leader>bb",
	"<cmd>lua require('dap').toggle_breakpoint()<cr>",
	keyopts({ desc = "Toggle Breakpoint" })
)
keymap.set(
	"n",
	"<leader>bB",
	"<cmd>lua require('dap').set_breakpoint(vim.fn.input '[Condition] > ')<cr>",
	keyopts({ desc = "Set Conditional BreakPoint" })
)
keymap.set("n", "<leader>bp", "<cmd>lua require('dap').pause.toggle()<cr>", keyopts({ desc = "Toggle Pause" }))
keymap.set("n", "<leader>br", "<cmd>lua require('dap').restart()<cr>", keyopts({ desc = "Restart Debugger" }))
keymap.set(
	"n",
	"<leader>bC",
	"<cmd>lua require('dap').run_to_cursor()<cr>",
	keyopts({ desc = "Run Session To Cursor" })
)
----------

-- Stepping Commands
------------
keymap.set("n", "<leader>bh", "<cmd>lua require('dap').step_back()<cr>", keyopts({ desc = "Step Back" }))
keymap.set("n", "<leader>bk", "<cmd>lua require('dap').step_into()<cr>", keyopts({ desc = "Step Into" }))
keymap.set("n", "<leader>bl", "<cmd>lua require('dap').step_over()<cr>", keyopts({ desc = "Step Over" }))
keymap.set("n", "<leader>bj", "<cmd>lua require('dap').step_out()<cr>", keyopts({ desc = "Step Out" }))
keymap.set("n", "<leader>bK", "<cmd>lua require('dap').up()<cr>", keyopts({ desc = "Step Up Call Stack" }))
keymap.set("n", "<leader>bJ", "<cmd>lua require('dap').down()<cr>", keyopts({ desc = "Step Down Call Stack" }))
------------

-- Dap REPL
------------
keymap.set("n", "<leader>bx", "<cmd>lua require('dap').repl.toggle()<cr>", keyopts({ desc = "Debug REPL Toggle" }))
------------

-- Session Commands
------------
keymap.set("n", "<leader>bss", "<cmd>lua require('dap').session()<cr>", keyopts({ desc = "Start Debug Session" }))
keymap.set("n", "<leader>bsc", "<cmd>lua require('dap').close()<cr>", keyopts({ desc = "Close Debug Session" }))
keymap.set("n", "<leader>bsa", "<cmd>lua require('dap').attach()<cr>", keyopts({ desc = "Attach Debug Session" }))
keymap.set("n", "<leader>bsd", "<cmd>lua require('dap').disconnect()<cr>", keyopts({ desc = "Detach Debug Session" }))
keymap.set("n", "<leader>bq", "<cmd>lua require('dap').terminate()<cr>", keyopts({ desc = "Quit Debug Session" }))
----------

-- UI Commands
----------
keymap.set("n", "<leader>bv", "<cmd>lua require('dap.ui.widgets').hover()<CR>", keyopts({ desc = "Variable Info" }))
keymap.set(
	"n",
	"<leader>bS",
	"<cmd> lua require ('dap.ui.widgets').cursor_float(require('dap.ui.widgets').scopes)<CR>",
	keyopts({ desc = "Scope Info" })
)
keymap.set(
	"n",
	"<leader>bF",
	"<cmd> lua require ('dap.ui.widgets').cursor_float(require('dap.ui.widgets').frames)<CR>",
	keyopts({ desc = "Stack Frame Info" })
)
keymap.set(
	"n",
	"<leader>be",
	"<cmd> lua require ('dap.ui.widgets').cursor_float(require('dap.ui.widgets').expressions)<CR>",
	keyopts({ desc = "Expression Info" })
)
----------

-- Telescope Commands
----------
keymap.set(
	"n",
	"<leader>bfc",
	'<cmd>lua require"telescope".extensions.dap.commands{}<CR>',
	keyopts({ desc = "Show Debug Command Palette" })
)
keymap.set(
	"n",
	"<leader>bfo",
	'<cmd>lua require"telescope".extensions.dap.configurations{}<CR>',
	keyopts({ desc = "Show Debug Options" })
)
keymap.set(
	"n",
	"<leader>bfb",
	'<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>',
	keyopts({ desc = "Show All BreakPoints" })
)
keymap.set(
	"n",
	"<leader>bfv",
	'<cmd>lua require"telescope".extensions.dap.variables{}<CR>',
	keyopts({ desc = "Show All Variables" })
)
keymap.set(
	"n",
	"<leader>bff",
	'<cmd>lua require"telescope".extensions.dap.frames{}<CR>',
	keyopts({ desc = "Show All Frames" })
)
----------

-- Language Specific Commands
----------
keymap.set("n", "<leader>bPm", "<cmd>lua require('dap-python').test_method()<CR>", keyopts({ desc = "Test Method" }))
keymap.set("n", "<leader>bPc", "<cmd>lua require('dap-python').test_class()<CR>", keyopts({ desc = "Test Class" }))
keymap.set(
	"n",
	"<leader>bPs",
	"<cmd>lua require('dap-python').debug_selection()<CR>",
	keyopts({ desc = "Debug Selected" })
)
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
