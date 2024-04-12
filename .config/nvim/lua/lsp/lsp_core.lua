--------------------
-- ############## --
-- # Lsp Config # --
-- ############## --
--------------------

--------------------------------
-- Lsp Config
--------------------------------

-- Options
----------
local lsp_options = function()
	----------
	-- Options
	----------
	vim.b["max_line_length"] = 0
	vim.lsp.handlers["textDocument/hover"] =
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
local lsp_mappings = function()
	----------
	-- Requires
	----------
	local lreq = "lua require"
	local lk = require("core.keymaps").lk
	local nmap = require("core.utils").norm_keyset
	----------
	--Mappings
	----------
	nmap("gw", "lua vim.diagnostic.open_float()", "LSP: Open Diagnostics Window")
	nmap("g=", "lua vim.lsp.buf.code_action()", "LSP: Take Code Action")
	nmap("gi", "lua vim.lsp.buf.hover()", "LSP: Function & Library Info")
	nmap("gL", "lua ShortenLine()", "LSP: Shorten Line")
	nmap("[g", "lua vim.diagnostic.goto_prev()", "LSP: Previous Flag")
	nmap("]g", "lua vim.diagnostic.goto_next()", "LSP: Next Flag")
	nmap("[G", "lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})", "LSP: Next Error")
	nmap("]G", "lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})", "LSP: Previous Error")
	nmap(lk.codeAction.key .. "q", "LSPRestart", "Code Action:  Previous Error")
	nmap(lk.codeAction.key .. "R", "lua vim.lsp.buf.rename()", "Code Action:  Rename Item Under Cursor")
	nmap(lk.codeAction.key .. "h", "lua vim.lsp.buf.signature_help()", "Code Action:  Bring Up LSP Explanation")
	nmap(lk.codeAction.key .. "I", "LspInfo", "Code Action:  Show Info")
	nmap(lk.codeAction.key .. "D", "lua vim.lsp.buf.definition()", "Code Action:  Go To Definition")
	nmap(lk.codeAction.key .. "d", "lua vim.lsp.buf.declaration()", "Code Action:  Go To Declaration")
	nmap(lk.codeAction.key .. "i", "lua vim.lsp.buf.implementation()", "Code Action:  Go To Implementation")
	nmap(lk.codeAction.key .. "r", lreq .. "('telescope.builtin').lsp_references()", "Code Action:  Go to References")
	nmap(
		lk.codeAction.key .. "t",
		lreq .. "('telescope.builtin').lsp_type_definitions()",
		"Code Action:  Go To Type Definition"
	)
	nmap(lk.codeAction.key .. "p", lreq .. "('telescope.builtin').diagnostics()", "Show all Diagnostics")
	nmap(lk.codeAction.key .. "=", "lua vim.diagnostic.setqflist", "Quick Fix List")
	nmap(
		lk.codeAction.key .. "f",
		"lua require('conform').format({ async = true, lsp_fallback = true }); vim.print(\"Formatted\")",
		"Code Action:  Format Code"
	)
	nmap(
		lk.codeAction_symbols.key .. "w",
		lreq .. "('telescope.builtin').lsp_workspace_symbols.key()",
		"Code Action Symbols: Show Workspace Symbols"
	)
	nmap(
		lk.codeAction_symbols.key .. "d",
		lreq .. "('telescope.builtin').lsp_document_symbols()",
		"Code Action Symbols: Show Document Symbols"
	)
	----------
end
----------

-- LSP Setup
----------
local lsp_setup = function(tooling, capabilities)
	local tcat = require("core.utils").tableConcat
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			lsp_options()
			lsp_mappings()
		end,
	})
	for name, options in pairs(tooling) do
		require("lspconfig")[name].setup(tcat({ capabilities = capabilities }, options))
	end
end
----------

--------------------------------
-- Package Installs
--------------------------------

-- Install Function
----------
local package_setup = function(lang_tooling)
	----------
	-- Requires
	----------
	local tC = require("core.utils").tableConcat
	----------
	-- Create Install List
	local install_list =
		tC(lang_tooling.lsp, tC(lang_tooling.lint, tC(lang_tooling.format, tC(lang_tooling.dap.packages))))
	-- Setup and Install
	----------
	require("mason").setup({
		install_root_dir = os.getenv("HOME") .. "/.config/nvim/lua/lsp_servers",
	})
	require("mason-tool-installer").setup({
		ensure_installed = install_list,
	})
	----------
end
----------

-- Formatter
----------
local formatter_setup = function(langConf, script_name)
	-- Setup Function
	----------
	require("conform").setup({
		log_level = vim.log.levels.TRACE,
		formatters_by_ft = {
			[script_name] = require("core.utils").get_table_keys(langConf)
		},
		formatters = langConf,
	})
	----------
	-- Options
	----------
	require("core.utils").norm_keyset(
		require("core.keymaps").lk.codeAction_format.key,
		'lua require("conform").format({ async = true, lsp_fallback = true }); vim.print("Formatted")',
		"LSP: Format Code"
	)
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	----------
end
----------

--------------------------------
-- Linter Setup
--------------------------------

-- Setup
----------
local linter_setup = function(langConf, script_name)
	----------
	-- Setup Function
	----------
	vim.print("langConf")
	local lint = require("lint")
	lint.linters_by_ft[script_name] = { table.concat(require("core.utils").get_table_keys(langConf)) }
    for k, v in pairs(langConf) do
        if v ~= nil then
            for l, m in v do
                lint.linters[k][l] = m
            end
        end
    end
	----------
	-- Options
	----------
	vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufWinEnter", "BufEnter" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})
	vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufWinEnter", "BufEnter" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})
	----------
	-- Mappings
	----------
	require("core.utils").norm_keyset(
		require("core.keymaps").lk.codeAction_lint.key,
		"lua require('lint').try_lint()",
		"LSP: Try Lint"
	)
	----------
end
----------

-- Attach Cmp
----------
local cmp_setup = function(langConf)
	if langConf == nil then
		vim.print("Cannot load cmp sources, as they are not set up in ft module")
	else
		local cmp_sources_processed = {}
		local n = 0
		for k in pairs(langConf) do
			n = n + 1
			cmp_sources_processed[n] = { name = k }
		end
		require("lsp.cmp_setup").load(cmp_sources_processed)
	end
end
----------

--------------------------------
-- Attach Snippets
--------------------------------

-- Attach Func
----------
local snip_setup = function()
	----------
	-- Config
	----------
	require("luasnip").config.set_config({
		updateevents = "TextChanged,TextChangedI",
	})
	----------
	-- Load Snippets
	----------
	local snips_folder = vim.fn.stdpath("config") .. "/lua/snippets/"
	require("luasnip.loaders.from_lua").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load({ paths = snips_folder })
	----------
	-- Functions
	----------
	function SnipEditFile()
		local snips_file = snips_folder .. vim.bo.filetype .. ".lua"
		if not require("core.utils").file_exists(snips_file) then
			io.open(snips_file)
		end
		vim.cmd("e " .. snips_file)
	end

	----------
	-- Commands
	----------
	vim.api.nvim_create_user_command("LuaSnipEdit", ":lua SnipEditFile()<CR>", {})
	----------
	-- Mappings
	----------
	vim.keymap.set({ "i", "s" }, "<C-J>", function()
		require("snip").expand()
	end, { silent = true })
	vim.keymap.set({ "i", "s" }, "<C-L>", function()
		require("snip").jump(1)
	end, { silent = true })
	vim.keymap.set({ "i", "s" }, "<C-H>", function()
		require("snip").jump(-1)
	end, { silent = true })
	vim.keymap.set({ "i", "s" }, "<C-E>", function()
		if require("snip").choice_active() then
			require("snip").change_choice(1)
		end
	end, { silent = true })
	----------
end
----------

--------------------------------
-- Attach Dap
--------------------------------
local dap_setup = function(langConf, script_name)
	require("dap")
	require("lsp.dap_core")
    if langConf.configurations ~= nil then
	require("dap").configurations[script_name] = { langConf.configurations }
    end
    if langConf.adapters ~= nil then
	    require("dap").adapters = langConf.adapters
    end
end
----------

--------------------------------
-- Attach Injected
--------------------------------
local injected_setup = function()
	local nmap = require("core.utils").norm_keysetA
	local bo = vim.bo
	local lk = require("core.keymaps").lk
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
local set_signs = function()
	local signs = { Error = "󰅙 ", Warn = " ", Hint = " ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
end
----------

--------------------------------
-- Full Lang Tool Setup
--------------------------------
local lang_tool_setup = function(langConf, script_name)
	local capabilities = require("lsp.cmp_setup").capabilities()
	package_setup(langConf)
	lsp_setup(langConf.lsp, capabilities)
	cmp_setup(langConf.cmp_sources)
	formatter_setup(langConf.format, script_name)
	linter_setup(langConf.lint, script_name)
	dap_setup(langConf.dap, script_name)
	cmp_setup(langConf.cmp_sources)
	snip_setup()
	require("core.utils").set_shift_and_tab(langConf.shift)
	if langConf.injected then
		injected_setup()
	end
	if langConf.extraOpts ~= nil then
		langConf.extraOpts()
	end
	set_signs()
	require("which-key").register()
end
----------

--------------------------------
-- Module Table
--------------------------------

local M = {
	setup = lang_tool_setup,
}

return M

----------
