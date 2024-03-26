-------------------------------
-- ########################  --
-- # Notebook Vim Config  #  --
-- ########################  --
-------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
----------

-- Requires
----------
local ufuncs = require("personal_utils")
local lm = require("leader_mappings")
----------

-- Extra Vars
----------
local norm_keyset = ufuncs.norm_keyset
----------

-- Module Funcs
----------
function new_terminal(lang)
	vim.cmd("belowright vsplit term://" .. lang)
end

--------------------------------
-- Notebook Setup - quarto.nvim, molten-nvim: <leader>n
--------------------------------

local quarto = require("quarto")
quarto.setup({
	ft = { "quarto" },
	codeRunner = {
		enabled = true,
		default_method = "slime",
	},
	lspFeatures = {
		languages = { "r", "python", "bash", "lua", "html" },
	},
})

norm_keyset(lm.notebook .. "p", "QuartoPreview", "Open Notebook Preview")
