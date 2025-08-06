----------------------
-- ################ --
-- # Dap  Config  # --
-- ################ --
----------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------
local lk = require("config.keymaps").lk
local fn = vim.fn
local desc_map = require("config.utils").desc_keymap
--------------------------------
-- Debug Adapter Protocol
--------------------------------

-- Colors and Themes
----------
-- Symbols
fn.sign_define(
  "DapBreakpoint",
  { text = "󰃤", texthl = "DapBreakpointSymbol", linehl = "DapUIBreakpointsLine", numhl = "DapBreakpointsSymbol" }
)
fn.sign_define("DapBreakpointSymbol", {
  text = "󱏛",
  texthl = "DapBreakpointSymbol",
  linehl = "DapBreakpointSymbol",
  numhl = "DapBreakpointSymbol",
})
fn.sign_define(
  "DapStopped",
  { text = "", texthl = "DapStoppedSymbol", linehl = "DapStoppedSymbol", numhl = "DapStoppedSymbol" }
)
----------

----------
-- Mappings
----------

-- Running Commands (and pauses)
----------
desc_map({ "n" }, lk.debug, "c", function()
  require("dap").continue()
end, "Continue/Start Debug Run")
desc_map({ "n" }, lk.debug, "b", function()
  require("dap").toggle_breakpoint()
end, "Toggle Breakpoint")
desc_map({ "n" }, lk.debug, "B", function()
  require("dap").set_breakpoint(vim.fn.input("[Condition] > "))
end, "Set Conditional BreakPoint")
desc_map({ "n" }, lk.debug, "p", function()
  require("dap").pause.toggle()
end, "Toggle Pause")
desc_map({ "n" }, lk.debug, "r", function()
  require("dap").restart()
end, "Restart Debugger")
desc_map({ "n" }, lk.debug, "C", function()
  require("dap").run_to_cursor()
end, "Run Session To Cursor")
----------

-- Stepping Commands
------------
desc_map({ "n" }, lk.debug, "h", function()
  require("dap").step_back()
end, "Step Back")
desc_map({ "n" }, lk.debug, "k", function()
  require("dap").step_into()
end, "Step Into")
desc_map({ "n" }, lk.debug, "l", function()
  require("dap").step_over()
end, "Step Over")
desc_map({ "n" }, lk.debug, "j", function()
  require("dap").step_out()
end, "Step Out")
desc_map({ "n" }, lk.debug, "K", function()
  require("dap").up()
end, "Step Up Call Stack")
desc_map({ "n" }, lk.debug, "J", function()
  require("dap").down()
end, "Step Down Call Stack")
------------

-- Dap REPL
------------
desc_map({ "n" }, lk.debug, "x", function()
  require("dap").repl.toggle()
end, "Debug REPL Toggle")
------------

-- Session Commands
------------
desc_map({ "n" }, lk.debug_session, "s", "<CMD>lua require('dap').session()<CR>", "Start Debug Session")
desc_map({ "n" }, lk.debug_session, "c", "<CMD>lua require('dap').close()<CR>", "Close Debug Session")
desc_map({ "n" }, lk.debug_session, "a", "<CMD>lua require('dap').attach()<CR>", "Attach Debug Session")
desc_map({ "n" }, lk.debug_session, "d", "<CMD>lua require('dap').disconnect()<CR>", "Detach Debug Session")
desc_map({ "n" }, lk.debug, "q", "<CMD>lua require('dap').terminate()<CR>", "Quit Debug Session")
desc_map({ "n" }, lk.debug_session, "l", function()
  require("osv").launch({ port = 8086 })
  vim.print("Started Nvim Debugging")
end, "Launch Debug Server")
----------

-- UI Commands
----------
local duw = 'require("dap.ui.widgets")'
desc_map({ "n" }, lk.debug, "v", "<CMD>lua " .. duw .. ".hover()<CR>", "Variable Info")
desc_map({ "n" }, lk.debug, "S", "<CMD>lua " .. duw .. ".cursor_float(" .. duw .. ".scopes)<CR>", "Scope Info")
desc_map({ "n" }, lk.debug, "F", "<CMD>lua " .. duw .. ".cursor_float(" .. duw .. ".frames)<CR>", "Stack Frame Info")
desc_map(
  { "n" },
  lk.debug,
  "e",
  "<CMD>lua " .. duw .. ".cursor_float(" .. duw .. ".expressions)<CR>",
  "Expression Info"
)
----------

-- Telescope Commands
----------
desc_map(
  { "n" },
  lk.debug_fileView,
  "c",
  '<CMD>lua require"telescope".extensions.dap.commands{}<CR>',
  "Show Debug Command Palette"
)
desc_map(
  { "n" },
  lk.debug_fileView,
  "o",
  '<CMD>lua require"telescope".extensions.dap.configurations{}<CR>',
  "Show Debug Options"
)
desc_map(
  { "n" },
  lk.debug_fileView,
  "b",
  '<CMD>lua require"telescope".extensions.dap.list_breakpoints{}<CR>',
  "Show All BreakPoints"
)
desc_map(
  { "n" },
  lk.debug_fileView,
  "v",
  '<CMD>lua require"telescope".extensions.dap.variables{}<CR>',
  "Show All Variables"
)
desc_map({ "n" }, lk.debug_fileView, "f", '<CMD>lua require"telescope".extensions.dap.frames{}<CR>', "Show All Frames")
----------

-- Configuration Commands
----------
desc_map({ "n" }, lk.debug_config, "p", function()
  return "<cmd>lua print(vim.inspect((require 'dap'.configurations." .. vim.bo.filetype .. ")<CR>"
end, "[P]rint")
----------

--------------------------------
-- Virtual Text DAP
--------------------------------

require("nvim-dap-virtual-text").setup({})

----------
