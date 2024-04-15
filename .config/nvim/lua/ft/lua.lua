---------------------
-- ############### --
-- # Lua Config  # --
-- ############### --
---------------------

local M = {}
-- language server
M.lsp = {
	lua_ls = {
		package_name = "lua-language-server",
		settings = {
			Lua = {
				diagnostics = { globals = { "vim", "quarto", "require", "table", "string" } },
				runtime = { verions = "LuaJIT" },
				completion = { autoRequire = false, callSnippet = "Replace" },
				telemetry = { enable = false },
			},
		},
	},
}
-- cmp sources
M.cmp_sources = {
	"luasnip",
	"nvim_lsp",
	"nvim_lsp_document_symbol",
	"nvim_lua",
	"path",
	"buffer",
	"treesitter",
}
-- linter
M.lint = {
	luacheck = {
		cmd = "luacheck",
		args = { "--globals", "vim" },
		ignore_exitcode = true,
		parser = require("lint").linters.luacheck.parser,
	},
}
-- formatter
M.format = { stylua = {
	indent_type = "Spaces",
	indent_width = 2,
} }
-- debugger
M.dap = {
	packages = {},
	configurations = {
        lua = {
        type = "nlua", request = "attach", name = "Attach to running Neovim Instance" },
    },
	adapters = {
		nlua = function(callback, opts)
			callback({
				type = "server",
				host = opts.host or "127.0.0.1",
				port = opts.port or 8086,
			})
		end,
	},
}
-- shift length
M.shift = 2

return M
