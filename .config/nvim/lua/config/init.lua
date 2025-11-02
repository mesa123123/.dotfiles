local M = {}

M.utils = require("config.utils")
M.commands = require("config.commands")
M.lsp_config = require("config.lsp_config")
M.dap_config = require("config.dap_config")
M.options = require("config.options")
M.filetree = require("config.filetree")
-- M.filetypes = require("config.filetypes")
M.keymaps = require("config.keymaps")
M.line_config = require("config.line")
M.theme = require("config.theme")
M.snips = require("config.snips_setup")
M.vcs = require("config.vcs")
M.workspace = require("config.workspace")

return M
