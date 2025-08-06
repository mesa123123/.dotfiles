--------------------------------

-- ############################  --
-- #  Version Control Config  #  --
-- ############################  --
--------------------------------

---------------------------------
-- Module Table
---------------------------------

local M = {}

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Requires
----------
local lk = require("config.keymaps").lk
local descMap = require("config.utils").desc_keymap
----------

--------------------------------
-- Mappings
--------------------------------

-- Key mappings
----------
M.mappings = function()
  -- Regular Mappings
  descMap({ "n" }, lk.vcs, "w", "<cmd>G blame<CR>", "Git [W]ho? (Blame)")
  descMap({ "n" }, lk.vcs, "m", "<cmd>G mergetool<CR>", "Git [M]ergetool")
  descMap({ "n" }, lk.vcs, "a", "<cmd>Gwrite<CR>", "[A]dd Current File")
  descMap({ "n" }, lk.vcs, "A", "<cmd>G add .<CR>", "[A]dd [A]ll Files")
  descMap({ "n" }, lk.vcs, "c", ":Git commit -m \"", "Make a [C]ommit")
  descMap({ "n" }, lk.vcs, "p", "<cmd>Git push origin<CR>", "[P]ush to Origin")
  descMap({ "n" }, lk.vcs, "s", "<cmd>Git<CR>", "[S]tatus report")
end
----------

-- Telescope Mappings
----------
M.tele_mappings = function()
  if pcall(require, "telescope") then
    descMap({ "n" }, lk.vcs_file, "c", "<cmd>Telescope git_commits theme=dropdown theme=dropdown<cr>", "Git [C]ommits")
    descMap({ "n" }, lk.vcs_file, "s", "<cmd>Telescope git_status theme=dropdown<cr>", "Git [S]tatus")
    descMap({ "n" }, lk.vcs_file, "b", "<cmd>Telescope git_branches theme=dropdown<cr>", "Git [B]ranches")
    descMap({ "n" }, lk.vcs_file, "f", "<cmd>Telescope git_files theme=dropdown<cr>", "Git [F]iles")
  else
    vim.error("Telescope is either not loaded or not installed")
  end
end
----------

-- Mergetool Mappings
----------
M.mergetool_mappings = function()
  descMap({ "n" }, lk.vcs, "l", ":diffget REMOTE<CR>", "Merge Take Right")
  descMap({ "n" }, lk.vcs, "h", ":diffget LOCAL<CR>", "Merge Take Left")
  descMap({ "n" }, lk.vcs, "j", "]c", "Merge [J]ext Conflict")
  descMap({ "n" }, lk.vcs, "k", "[c", "Merge [K]revious Conflict")
end
----------

--------------------------------
-- Return Table
--------------------------------

return M
----------
