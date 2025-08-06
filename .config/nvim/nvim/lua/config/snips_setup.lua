--------------------
-- ################ --
-- # Snips Config # --
-- ################ --
--------------------

-- Module table
----------
local M = {}
----------

--------------------------------
-- Attach Snippets
--------------------------------

-- Functions
----------
M.edit_snip = function()
  local snips_file = vim.fn.stdpath('config') .. "/snippets" .. vim.bo.filetype .. ".json"
  if not require("base.utils").fileExists(snips_file) then
    io.open(snips_file)
  end
  vim.cmd("e " .. snips_file)
end
----------

----------
-- Mappings
----------

M.snip_maps = function()
  local snip_forward = function()
    if vim.snippet.active({ direction = 1 }) then
      vim.snippet.jump(1)
    else
      vim.print("Cannot Jump Snippet Forward")
    end
  end
  local snip_back = function()
    if vim.snippet.active({ direction = -1 }) then
      vim.snippet.jump(-1)
    else
      vim.print("Cannot Jump Snippet Back")
    end
  end
  local snip_stop = function()
    if vim.snippet.active() then
      vim.snippet.stop()
    else
      vim.print("No active snippet")
    end
  end
  vim.keymap.set({ "n", "i" }, "<A-l>", snip_forward, { silent = true, noremap = true, desc = "Snip Jump Forward" })
  vim.keymap.set({ "n", "i" }, "<A-h>", snip_back, { silent = true, noremap = true, desc = "Snip Jump Back" })
  vim.keymap.set({ "n", "i" }, "<A-j>", snip_stop, { silent = true, noremap = true, desc = "Snip Stop" })
  vim.api.nvim_create_user_command("EditSnipFile", M.edit_snip, {})
end

--------------------------------
-- Return Table
--------------------------------

return M

----------
