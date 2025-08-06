--------------------------------
-- ########################  --
-- #  Status Line Config  #  --
-- ########################  --
--------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

local lk = require("base.keymaps").lk
local nmap = require("base.utils").norm_keyset
local fn = vim.fn
local cmd = vim.cmd
local keymap = vim.keymap

--------------------------------
-- Mappings
--------------------------------
-- Mappings
----------
-- General
keymap.set("t", "<leader>q", "<CR>exit<CR><CR>", { noremap = true, silent = true, desc = "Quit Terminal Instance" })
keymap.set("t", "<Esc>", "<c-\\><c-n>", { noremap = true, silent = true, desc = "Change to N mode" })
keymap.set(
  "t",
  "vim",
  "say \"You're already in vim! You're a dumb ass!\"",
  { noremap = true, silent = true, desc = "Stop you from inceptioning vim" }
)
keymap.set(
  "t",
  "editvim",
  'say "You\'re already in vim! This is why no one loves you!"',
  { noremap = true, silent = true, desc = "Stop you from inceptioning vim" }
)
-- Standard Term Toggle
nmap(lk.terminal.key .. "t", "lua Standard_term_toggle()", "Toggle Terminal")
-- Docker Toggle
nmap(lk.terminal.key .. "d", "lua Docker_term_toggle()", "Open Docker Container Management")
-- Gitui Toggle
nmap(lk.terminal.key .. "g", "lua Gitui_term_toggle()", "Open Git Ui")
----------
