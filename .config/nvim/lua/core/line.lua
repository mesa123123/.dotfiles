--------------------------------
-- ########################  --
-- #  Status Line Config  #  --
-- ########################  --
--------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Requires
----------
-- Modules
local palette = require("core.colors").palette
local theme = require("core.theme")
lm = require("core.keymaps").leadermaps
----------

----------
-- Helper Functions
----------

-- Get accurate time on panel
----------
function Zonedtime(hours)
  -- Change time zone here (default seems to be +12 on home workstation)
  local zone_difference = 11
  local t = os.time() - (zone_difference * 3600)
  local d = t + hours * 3600
  return os.date("%H:%M %Y-%m-%d", d)
end
----------

-- Truncate components on smaller windows
------------------
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
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

-- Linting, Formatting, Lsp, Dap Info
------------------
-- LSP
local active_lsp = {
  function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lsps = vim.lsp.get_active_clients({ bufnr })
    if lsps and #lsps > 0 then
      local names = {}
      for _, lsp in ipairs(lsps) do
        table.insert(names, lsp.name)
      end
      return string.format(" %s", table.concat(names, ", "))
    else
      return ""
    end
  end,
  color = { fg = palette.bright_red },
  fmt = trunc(120, 3, 90, true),
}
-- Formatter
local active_formatter = {
  function()
    local formatters = require("conform").list_formatters_for_buffer(0)
    if formatters ~= nil then
      return string.format(" %s", table.concat(formatters, ", "))
    else
      return ""
    end
  end,
  color = { fg = palette.bright_green },
  fmt = trunc(120, 3, 90, true),
}
-- Linter
local active_lint = {
  function()
    local linters = require("lint").linters_by_ft[vim.bo.filetype][1]
    if linters ~= nil then
      return string.format("󰯠 %s", linters)
    else
      return ""
    end
  end,
  color = { fg = palette.bright_yellow },
  fmt = trunc(120, 4, 90, true),
}
-- Debugger
local debug_status = {
  function()
    local status = require("dap").status()
    if status ~= "" then
      return string.format("󰃤 %s", status)
    else
      return ""
    end
  end,
  color = { fg = palette.dark_red },
  fmt = trunc(120, 4, 90, true),
}
------------------

-- Show if a macro is recording
------------------
local recording = {
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

-----------------------------
-- Status Line 
-----------------------------

-- Config
----------
return {
  options = {
    section_separators = { left = " ", right = " " },
    component_separators = { left = "", right = "" },
    theme = theme.line_theme,
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(res)
          return res:sub(1, 1)
        end,
      },
      recording,
    },
    lualine_b = {
      "branch",
      {
        "diff",
        symbols = { added = "+", modified = "~", removed = "-" },
        fmt = trunc(120, 10000, 120, true),
      },
      {
        "diagnostics",
        symbols = { error = "", warn = "", info = "", hint = "" },
        fmt = trunc(120, 10000, 120, true),
      },
    },
    lualine_c = {
       { "filetype", colored = true, icon_only = true, icon = { align = "right" }, fmt = trunc(120, 4, 90, true) },
       debug_status,
      -- { "overseer", colored = false },
    },
    lualine_x = { active_lsp, active_lint, active_formatter },
    lualine_y = { { "progress", fmt = trunc(120, 10000, 120, true) }, { "location" } },
    lualine_z = { "Zonedtime(11)" },
  },
}
----------
