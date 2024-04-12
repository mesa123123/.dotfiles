--------------------------
-- ###################  --
-- # Python  Config  #  --
-- ###################  --
--------------------------

-- Requires
----------
local lint = require("lint")
----------

local M = {}

M.ext = "py"

M.lsp = {
	pyright = {
		on_init = function(client)
			client.config.settings.python.pythonPath = require("core.utils").get_python_path()
		end,
	},
}
M.lint = {
	pylint = {
		cmd = require("core.utils").get_venv_command("pylint"),
		ignore_exit_code = true,
		parser = lint.linters.pylint.parser()
	},
}
M.format = { black = { }, isort = {}, injected = {} }
M.injected = true
M.extraOpts = function()
	local dappy = require("dap-python")
	dappy.setup(require("core.utils").python_path)
	dappy.test_runner = "pytest"

	local nmap = require("core.utils").norm_keyset
	local lk = require("core.keymaps").lk
	local lreq = "lua require"

	nmap(lk.debug_python.key .. "m", lreq .. "('dap-python').test_method()", "Test Method")
	nmap(lk.debug_python.key .. "c", lreq .. "('dap-python').test_class()", "Test Class")
	nmap(lk.debug_python.key .. "s", lreq .. "('dap-python').debug_selection()", "Debug Selected")
end
M.dap = { debugpy = {
    
} }
M.shift = 4

return M
