-- File: /Users/pbowman2/.config/nvim/lsp/ty.lua

local get_venv_command = require("config.utils").get_venv_command

return {
  cmd = { get_venv_command("ty"), "server" },
  filetypes = { "python" },
  root_dir = vim.fs.dirname(vim.fs.find({ ".git", "pyproject.toml" }, { upward = true })[1]),
}
