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

--------------------------------
-- Notebook Setup - quarto.nvim, molten-nvim: <leader>n
--------------------------------

-- local quarto = require("quarto")
-- quarto.setup({
-- 	codeRunner = {
-- 		enables = true,
-- 		ft_runners = { python = "molten" },
-- 	},
-- })
--
-- norm_keyset(lm.notebook .. "p", "QuartoPreview", "Open Notebook Preview")
-- -- norm_keyset(lm.notebook .. "x", 'MoltenInit', "Initalize Notebook Kernel")
-- -- norm_keyset(lm.notebook_kernel .. "i", 'MoltenInfo', "Kernel Info")
-- -- norm_keyset(lm.notebook .. "q", 'MoltenDeinit', "Shutdown Kernel")
-- vim.keymap.set("n", "<localleader>ni", ":MoltenInit<CR>",
--     { silent = true, desc = "Initialize the plugin" })
