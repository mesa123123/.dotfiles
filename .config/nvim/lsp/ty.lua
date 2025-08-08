---@brief
---
--- https://github.com/astral-sh/ty
---
--- A Language Server Protocol implementation for ty, an extremely fast Python type checker and language server, written in Rust.
---
--- For installation instructions, please refer to the [ty documentation](https://github.com/astral-sh/ty/blob/main/README.md#getting-started).
return {
  cmd = { require("config.utils").get_venv_command("ty"), "server" },
  filetypes = { "python" },
  root_dir = vim.fs.root(0, { ".git/", "pyproject.toml" }),
}
