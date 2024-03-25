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
----------

-- Extra Vars
----------
local norm_keyset = ufuncs.norm_keyset
----------

--------------------------------
-- Notebook Setup - quarto.nvim, molten-nvim: <leader>n
--------------------------------

local quarto = require("quarto")
quarto.setup({
	codeRunner = {
		enables = true,
		default_runners = { python = "molten" },
	},
})

norm_keyset("<leader>np", "lua require(\"quarto.quartoPreview\")", "Open Notebook Preview")
