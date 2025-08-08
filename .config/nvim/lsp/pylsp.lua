---@brief
---
--- https://github.com/python-lsp/python-lsp-server
---
--- A Python 3.6+ implementation of the Language Server Protocol.
---
--- See the [project's README](https://github.com/python-lsp/python-lsp-server) for installation instructions.
---
--- Configuration options are documented [here](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md).
--- In order to configure an option, it must be translated to a nested Lua table and included in the `settings` argument to the `config('pylsp', {})` function.
--- For example, in order to set the `pylsp.plugins.pycodestyle.ignore` option:
--- ```lua
--- vim.lsp.config('pylsp', {
---   settings = {
---     pylsp = {
---       plugins = {
---         pycodestyle = {
---           ignore = {'W391'},
---           maxLineLength = 100
---         }
---       }
---     }
---   }
--- })
--- ```
---
--- Note: This is a community fork of `pyls`.
return {

  cmd = { require("config.utils").get_venv_command("pylsp") },
  filetypes = { "python", "py" },
  settings = {
    pylsp = {
      plugins = {
        jedi_signature_help = { enabled = true },
        jedi_completion = { enabled = true },
        pycodestyle = { enabled = false },
        mccabe = { enabled = false },
        pyflakes = { enabled = false },
        flake8 = { enabled = false },
        pylint = { enabled = false },
        pylsp_mypy = { enabled = true },
        pyls_isort = { enabled = false },
      },
    },
  },
  root_markers = {
    ".git",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
  },
}
