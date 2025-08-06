----------------------
-- ################ --
-- # Dap  Config  # --
-- ################ --
----------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

local hl = vim.api.nvim_set_hl
local palette = require("core.theme").palette
local lk = require("core.keymaps").lk
local lreq = "lua require"
local fn = vim.fn
local nmap = require('core.utils').norm_keyset
--------------------------------
-- Debug Adapter Protocol
--------------------------------

-- Colors and Themes
----------
-- Colors
hl(0, "DapBreakpoint", { ctermbg = 0, fg = palette.bright_red, bg = palette.dark0_soft })
hl(0, "DapBreakpointCondition", { ctermbg = 0, fg = palette.bright_red, bg = palette.dark0_soft })
hl(0, "DapLogPoint", { ctermbg = 0, fg = palette.neutral_blue, bg = palette.dark0_soft })
hl(0, "DapStopped", { ctermbg = 0, fg = palette.netural_red, bg = palette.dark0_soft })
-- Symbols
fn.sign_define(
  "DapBreakpoint",
  { text = "󰃤", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
fn.sign_define("DapBreakpointCondition", {
  text = "󱏛",
  texthl = "DapBreakpointCondition",
  linehl = "DapBreakpointCondition",
  numhl = "DapBreakpointCondition",
})
fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
----------

----------
-- Mappings
----------

-- Running Commands (and pauses)
----------
nmap(lk.debug.key .. "c", lreq .. "('dap').continue()", "Continue/Start Debug Run")
nmap(lk.debug.key .. "b", lreq .. "('dap').toggle_breakpoint()", "Toggle Breakpoint")
nmap(lk.debug.key .. "B", lreq .. "('dap').set_breakpoint(vim.fn.input '[Condition] > ')", "Set Conditional BreakPoint")
nmap(lk.debug.key .. "p", lreq .. "('dap').pause.toggle()", "Toggle Pause")
nmap(lk.debug.key .. "r", lreq .. "('dap').restart()", "Restart Debugger")
nmap(lk.debug.key .. "C", lreq .. "('dap').run_to_cursor()", "Run Session To Cursor")
----------

-- Stepping Commands
------------
nmap(lk.debug.key .. "h", lreq .. "('dap').step_back()", "Step Back")
nmap(lk.debug.key .. "k", lreq .. "('dap').step_into()", "Step Into")
nmap(lk.debug.key .. "l", lreq .. "('dap').step_over()", "Step Over")
nmap(lk.debug.key .. "j", lreq .. "('dap').step_out()", "Step Out")
nmap(lk.debug.key .. "K", lreq .. "('dap').up()", "Step Up Call Stack")
nmap(lk.debug.key .. "J", lreq .. "('dap').down()", "Step Down Call Stack")
------------

-- Dap REPL
------------
nmap(lk.debug.key .. "x", lreq .. "('dap').repl.toggle()", "Debug REPL Toggle")
------------

-- Session Commands
------------
nmap(lk.debug_session.key .. "s", lreq .. "('dap').session()", "Start Debug Session")
nmap(lk.debug_session.key .. "c", lreq .. "('dap').close()", "Close Debug Session")
nmap(lk.debug_session.key .. "a", lreq .. "('dap').attach()", "Attach Debug Session")
nmap(lk.debug_session.key .. "d", lreq .. "('dap').disconnect()", "Detach Debug Session")
nmap(lk.debug.key .. "q", lreq .. "('dap').terminate()", "Quit Debug Session")
nmap(lk.debug_session.key .. "l", lreq .. "('osv').launch({port=8086})", "Launch Debug Server")
----------

-- UI Commands
----------
local duw = 'require("dap.ui.widgets")'
nmap(lk.debug.key .. "v", "lua " .. duw .. ".hover()", "Variable Info")
nmap(lk.debug.key .. "S", "lua " .. duw .. ".cursor_float(" .. duw .. ".scopes)", "Scope Info")
nmap(lk.debug.key .. "F", "lua " .. duw .. ".cursor_float(" .. duw .. ".frames)", "Stack Frame Info")
nmap(lk.debug.key .. "e", "lua " .. duw .. ".cursor_float(" .. duw .. ".expressions)", "Expression Info")
----------

-- Telescope Commands
----------
nmap(lk.debug_fileView.key .. "c", lreq .. '"telescope".extensions.dap.commands{}', "Show Debug Command Palette")
nmap(lk.debug_fileView.key .. "o", lreq .. '"telescope".extensions.dap.configurations{}', "Show Debug Options")
nmap(lk.debug_fileView.key .. "b", lreq .. '"telescope".extensions.dap.list_breakpoints{}', "Show All BreakPoints")
nmap(lk.debug_fileView.key .. "v", lreq .. '"telescope".extensions.dap.variables{}', "Show All Variables")
nmap(lk.debug_fileView.key .. "f", lreq .. '"telescope".extensions.dap.frames{}', "Show All Frames")
----------

--------------------------------
-- Virtual Text DAP
--------------------------------

require("nvim-dap-virtual-text").setup({})

----------


