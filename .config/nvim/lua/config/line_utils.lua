--------------------------------
-- ########################  --
-- #  Status Line Utils  #   --
-- ########################  --
--------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Module table
----------
local M = {}
----------

-- Requires
----------
-- Modules
local palette = require("config.colors").palette
local set = require("config.utils").unique
----------

--------------------------------
-- Utilities
--------------------------------

-- Truncate components on smaller windows
------------------
M.trunc = function(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ""
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
    end
    return str
  end
end
------------------

-- Get accurate time on panel
----------
M.zonedtime = {
  function()
    return os.date("%H:%M %Y-%m-%d", os.time())
  end,
  fmt = M.trunc(30, 50, 10, true),
}
----------

-- Linting, Formatting, Lsp, Dap Info
------------------
-- LSP
M.active_lsp = {
  function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lsps = vim.lsp.get_clients({ bufnr })
    if lsps and #lsps > 0 then
      local names = {}
      for _, lsp in ipairs(lsps) do
        table.insert(names, lsp.name)
      end
      local lsp_set = set(names)
      return string.format("  %s", table.concat(lsp_set, ", "))
    else
      return ""
    end
  end,
  color = { fg = palette.bright_red },
  fmt = M.trunc(120, 3, 90, true),
}
-- Formatter
M.active_formatter = {
  function()
    local formatters = require("conform").list_formatters_for_buffer(0)
    if formatters ~= nil then
      for i, v in pairs(formatters) do
        local pos = string.find(v, "_")
        if pos then
          formatters[i] = string.sub(v, 1, pos - 1)
        end
      end
      local formatters_set = set(formatters)
      return string.format(" %s", table.concat(formatters_set, ", "))
    else
      return ""
    end
  end,
  color = { fg = palette.bright_green },
  fmt = M.trunc(120, 3, 90, true),
}
-- Linter
M.active_lint = {
  function()
    local linters = require("lint").get_running()
    if #linters ~= 0 then
      return string.format("󰯠 %s", set(table.concat(linters, ", ")))
    else
      return ""
    end
  end,
  color = { fg = palette.bright_yellow },
  fmt = M.trunc(120, 4, 90, true),
}
-- Debugger
M.debug_status = {
  function()
    local status = require("dap").status()
    if status ~= "" then
      return string.format("󰃤 %s", status)
    else
      return ""
    end
  end,
  color = { fg = palette.dark_red },
  fmt = M.trunc(120, 4, 90, true),
}
------------------

-- Show if a macro is recording
------------------
M.recording = {
  function()
    local rec_status = vim.fn.reg_recording()
    if rec_status ~= "" then
      return string.format("󰑋 %s", string.sub(rec_status, string.len(rec_status)))
    else
      return ""
    end
  end,
  color = { fg = palette.dark0_hard },
}
------------------

-- Add venv name if a virtual environment is active
----------
M.virtualenv = {
  function()
    if vim.env.VIRTUAL_ENV then
      local venv_name = string.match(vim.env.VIRTUAL_ENV, "([^/]+)$")
      if venv_name == ".venv" or venv_name == ".env" then
        return ""
      else
        return venv_name .. " "
      end
    else
      return ""
    end
  end,
  color = { fg = palette.faded_blue },
}
----------

-- Show if spell_check is on
----------
M.active_spell = {
  function()
    if vim.wo.spell then
      local lang = vim.bo.spelllang
      if lang == "en" then
        return "󰓆 English"
      else
        return "󰓆"
      end
    else
      return ""
    end
  end,
  color = { fg = palette.bright_blue },
}
----------

-- Show if snippet is active
------------
M.active_snip = {
  function()
    if vim.snippet.active() then
      return ""
    else
      return ""
    end
  end,
  color = { fg = palette.light0_hard },
}
------------

-- is ai thinking
------------
local spinner_symbols = { "󱩎", "󱩏", "󱩒", "󱩕", "󰛨" }
local spinner_index = 1
local processing = false
-- Create autocmd to watch user events
vim.api.nvim_create_augroup("CodeCompanionHooks", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestFinished" },
  group = "CodeCompanionHooks",
  callback = function(event)
    processing = (event.match == "CodeCompanionRequestStarted")
  end,
})

-- this function is the lualine component
M.ai_thinking = {
  function()
    if processing then
      spinner_index = (spinner_index % #spinner_symbols) + 1
      return spinner_symbols[spinner_index]
    end
    return ""
  end,
  color = { palette.light0_hard },
}
------------

-- Bread crumbs Utility (Corrected Scope/Order)
----------
M.get_breadcrumbs = {
  function()
    return require("nvim-navic").get_location()
  end,
  cond = function()
    return require("nvim-navic").is_available()
  end,
  fmt = M.trunc(120, 4, 90, true),
}
----------

return M

----------
