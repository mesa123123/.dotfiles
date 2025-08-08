return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    Lua = {
      diagnostics = { globals = { "vim", "quarto", "require", "table", "string" } },
      workspace = {
        checkThirdParty = false,
        library = { vim.api.nvim_get_runtime_file("", true), vim.env.VIMRUNTIME },
      },
      runtime = { versions = "LuaJIT" },
      completion = { autoRequire = false },
      telemetry = { enable = false },
    },
  },
}
