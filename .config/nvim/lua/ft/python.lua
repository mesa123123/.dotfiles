--------------------------
-- ###################  --
-- # Python  Config  #  --
-- ###################  --
--------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
-- Api Exposures
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local fs = vim.fs -- vim filesystem
local keymap = vim.keymap -- keymaps
local lsp = vim.lsp -- Lsp inbuilt
local log = vim.log
local opt = vim.opt
-- Options
local bo = vim.bo -- bufferopts
-- For Variables
local b = vim.b -- buffer variables
G = vim.g -- global variables
local hl = api.nvim_set_hl -- highlighting
--------

-- Requires
----------
local config = require("lspconfig") -- Overall configuration for lsp
local tool_manager = require("mason")
local tool_installer = require("mason-tool-installer")
local cmp_setup = require("lsp.cmp_setup") -- Autocompletion for the language servers
local lsp_opts = require("lsp.options").options
local dap = require("dap")
local daptext = require("nvim-dap-virtual-text")
local lint = require("lint")
local format = require("conform")
local snip = require("luasnip")
local snipload_lua = require("luasnip.loaders.from_lua")
local snipload_vscode = require("luasnip.loaders.from_vscode")
local dappy = require("dap-python")
local putils = require("core").utils
local lm = require("leader_mappings")
----------

-- Extra Vars
----------
local nmap = putils.norm_keyset
local tableConcat = putils.tableConcat
local scandir_menu = putils.scandirMenu
local get_venv_command = putils.get_venv_command
local file_exists = putils.fileExists
local get_python_path = putils.get_python_path
----------

-- Compressing Text w/Vars
----------
local lreq = "lua require"
----------


local lang_tooling = {
    lsp = { "pyright" },
    lint = {"pylint" },
    format = { "black", "isort" },
    dap = { "debugpy" }
}

install_tools = function(lang_tooling)
    local tool_installer = require("mason-tool-installer")
    tool_installer.setup({ tableConcat(lang_tooling.lsp, tableConcat(lang_tooling.lint, tableConcat(lang_tooling.format, tableConcat(encure_installed.dap)))),
        ensure_installed = 
        auto_update = true
    })
end

lint

format.formatters_by_ft = tableConcat(format.formatters_by_ft, {
        python = lang_tooling.format
    })

config.lang_tooling.lsp[0].setup(lsp_opts({}))
dap.configurations.python = {

}
