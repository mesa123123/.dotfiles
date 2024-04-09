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
local cmd = vim.cmd
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local ft = vim.filetype
local hl = vim.api.nvim_set_hl
local diagnostic = vim.diagnostic
local opt = vim.opt
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
    -- Term Gui Col True
    opt.termguicolors = true
    -- Line Numbers On
    opt.relativenumber = true
    opt.number = true
    opt.cursorline = true
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
    -- Conceal Level
    opt.conceallevel = 1
    -- Mouse off
    opt.mouse = ""
    -- Spell Check On
    opt.spell = true
    -- toggle spellcheck
    api.nvim_create_user_command("SpellCheckToggle", function()
      vim.opt.spell = not (vim.opt.spell:get())
    end, { nargs = 0 })

    --------------------------------
    -- Settings
    --------------------------------
    gv["EditorConfig_exclude_patterns"] = { "fugitive://.*", "scp://.*" }
    -- Virtual Text Enabled Globally
    diagnostic.config({
      virtual_text = true,
      underline = true,
      signs = true,
    })
    ------------

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
    ----------

    --------------------------------
    -- Register Settings (Copy, Paste)
    --------------------------------
    -- Setup Config for xfce4 desktops to use system keyboard
    ----------
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
    ----------
end

return M

