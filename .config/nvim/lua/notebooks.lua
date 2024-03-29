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
local otter = require("otter")
local keymap = vim.keymap
local gv = vim.g
----------

-- Extra Vars
----------
local norm_keyset = ufuncs.norm_keyset
local keyopts = ufuncs.keyopts
----------

-- Functions
----------
-- Module Funcs
local export_notebook = function()
  otter.export(true)
end
-- Global Funcs
New_repl = function(lang)
  vim.cmd("belowright vsplit term://" .. lang)
end
----------

--------------------------------
-- Notebook Setup - quarto.nvim, molten-nvim: <leader>n
--------------------------------

-- Setup
----------
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
----------

-- Options
----------
gv["slime_target"] = "vimterminal"
gv["slime_vimterminal_cmd"] = "ipython"
----------

-- Mappings
----------
norm_keyset(lm.notebook .. "p", "QuartoPreview", "Open Notebook Preview")
keymap.set("n", lm.notebook .. "w", export_notebook, keyopts({ desc = "Open Notebook Preview" }))
norm_keyset(lm.notebook_kernel .. "k", "QuartoActivate", "Activate Quarto")
norm_keyset(lm.notebook_kernel .. "p", "lua New_repl('python')", "New Python Terminal")
norm_keyset(lm.notebook_kernel .. "i", "lua New_repl('ipython')", "New Python Terminal")
norm_keyset(lm.notebook_run .. "a", "QuartoSendAbove", "Run Cell [A]bove")
norm_keyset(lm.notebook_run .. "r", "QuartoSendAll", "[R]un All")
norm_keyset(lm.notebook_run .. "b", "QuartoSendAbove", "Run Cell [B]elow")
----------



