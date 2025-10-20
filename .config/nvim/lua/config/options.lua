--------------------------------
-- ######################  --
-- #  Options Config    #  --
-- ######################  --
--------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

-- Vim Vars
----------
local gv = vim.g
----------

-- Local Table
----------
local M = {}
----------

--------------------------------
-- Options
--------------------------------

M.setup = function()
  local opt = vim.opt
  local api = vim.api

  -- Line Numbers On
  --
  opt.relativenumber = true
  opt.number = true
  -- Other Encoding and Formatting settings
  opt.linebreak = true
  opt.autoindent = true
  opt.encoding = "UTF-8"
  opt.showmode = false
  opt.splitbelow = true
  opt.signcolumn = "yes"
  -- Default Tabstop & Shiftwidth
  opt.tabstop = 4
  opt.shiftwidth = 4
  opt.expandtab = true
  -- Status Line
  opt.laststatus = 2
  opt.showtabline = 0
  -- Conceal Level
  opt.conceallevel = 1
  -- Mouse off
  opt.mouse = "a"
  opt.winborder = "rounded"
  -- Spell Check On
  opt.spell = true
  opt.spelllang = "en_gb"
  -- toggle spellcheck
  api.nvim_create_user_command("SpellCheckToggle", function()
    vim.opt.spell = not (vim.opt.spell:get())
  end, { nargs = 0 })
  -- Buffer Opts
  opt.swapfile = false
  --------------------------------
  -- Settings
  --------------------------------
  gv["EditorConfig_exclude_patterns"] = { "fugitive://.*", "scp://.*" }
  gv.loaded_sql_completion = false
  -- AutoCmds
  ----------
  -- Create Group
  api.nvim_create_augroup("onYank", { clear = true })
  -- Highlight on Yank
  api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = "onYank",
    callback = function()
      vim.highlight.on_yank()
    end,
  })
  ----------

  -- Code Folding
  ----------
  opt.foldmethod = "expr"
  opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  opt.foldtext = "v:lua.vim.treesitter.foldtext()"
  opt.foldlevelstart = 99
  gv.markdown_folding = 1
  ----------

  --------------------------------
  -- Register Settings (Copy, Paste)
  --------------------------------
  -- For macs just sync the system clipboard
  ----------
  if vim.fn.has("macunix") == 1 then
    opt.clipboard = "unnamedplus"
  -- Setup Config for xfce4 desktops to use system keyboard
  ----------
  else
    gv["clipboard"] = {
      name = "xclip-xfce4-clipman",
      copy = {
        ["+"] = "xclip -selection clipboard",
        ["*"] = "xclip -selection clipboard",
      },
      paste = {
        ["+"] = "xclip -selection clipboard -o",
        ["*"] = "xclip -selection clipboard -o",
      },
      cache_enabled = true,
    }
  end
  ----------
end
return M
