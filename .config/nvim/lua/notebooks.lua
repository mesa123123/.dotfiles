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
local keymap = vim.keymap
local gv = vim.g
local system = vim.fn.system
local cmd = vim.cmd
local api = vim.api
----------

-- Requires
----------
local ufuncs = require("personal_utils")
local lm = require("leader_mappings")
local otter = require("otter")
local notify = require("notify")
----------

-- Extra Vars
----------
local norm_keyset = ufuncs.norm_keyset
local keyopts = ufuncs.keyopts
local python_path = ufuncs.get_python_path()
local ensure_install = ufuncs.ensure_install
----------

-- Ensure Installed Packages On Notebook Open
----------
api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = "*.qmd",
  callback = function()
    ensure_install("python", {
      "ipykernel",
      "black",
      "pynvim",
      "jupyter_client",
      "cariosvg",
      "pnglatex",
      "plotly",
      "kaleido",
      "pyperclip",
      "nbformat",
      "pillow",
    })
    cmd("QuartoActivate")
  end,
})
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
-- Launch Molten (Kernel Runner)
local molten_launch = function()
  filetype = vim.bo.filetype
  if vim.bo.filetype ~= "quarto" then
    notify("You're not in a notebook silly!", "error")
    return 0
  end
  print("Finding Kernels")
  -- check if there is a kernel called "molten"
  local kernels = system({ "jupyter", "kernelspec", "list" })
  print("Found These: " .. kernels)
  -- if so return that
  if string.find(kernels, "molten") == nil then
    print("kernel named molten not installed, installing")
    -- Get all pip packages
    local pip_packs = system({ "pip", "list" })
    -- check if ipykernel is amoung them
    if string.find(pip_packs, "ipykernel") == nil then
      print("Installing ipykernel")
      system({ "pip", "install", "ipykernel" })
    end
    print("Creating Molten Kernel")
    system({ "python", "-m", "ipykernel", "install", "--user", "--name", "molten" })
  else
    print("molten kernel installed")
  end
  cmd("MoltenInit molten")
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
    default_method = "molten",
  },
  lspFeatures = {
    languages = { "r", "python", "bash", "lua", "html" },
  },
})

----------

-- Options
----------
gv["python3_host_prog"] = python_path
----------

-- Mappings
----------
norm_keyset(lm.notebook .. "p", "QuartoPreview", "Open Notebook Preview")
keymap.set("n", lm.notebook .. "w", export_notebook, keyopts({ desc = "Export Notebook to Code" }))
keymap.set("n", lm.notebook_kernel .. "k", molten_launch, keyopts({ desc = "Start Kernel" }))
norm_keyset(lm.notebook_run .. "a", "QuartoSendAbove", "Run Cell [A]bove")
norm_keyset(lm.notebook_run .. "r", "QuartoSendAll", "[R]un All")
norm_keyset(lm.notebook_run .. "b", "QuartoSendAbove", "Run Cell [B]elow")
----------
