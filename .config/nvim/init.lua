--------------------------------
-- TO DO
--------------------------------

-- 1. Learn LuaSnip
--      a. Rewrite Snippets for Lua
--      b. Restructure Snippets so only that format of Snippets loads
-- 2. Learn How LSP works
-- 3. Make the modes on LuaLine Single Char
-- 4. Figure out how to get the bloody repl working

----------------------------------

-------------------------------
-- Priority Settings
--------------------------------
-- Set the config path
vim.g["config_path"] = "~/config/nvim"
-- Set the mapleader
vim.g["mapleader"] = "\\"
-- Set Coc_Config_Home
vim.g["coc_config_home"] = '/home/$USER/.vim/'

--------------------------------
-- Luaisms for Vim Stuff
--------------------------------

-- Variables
----------
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local g = vim.g -- global variables
local opt = vim.opt -- vim options
local gopt = vim.o -- global options
local bopt = vim.bo -- buffer options
local wopt = vim.wo -- window options

-- Functions
--------

-- Function for Mapping Keybindings with "map"
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

----------------

--------------------------------
-- Plugin Loading and Settings
--------------------------------
-- Install Packer and Sync if required (vim-plug was going to be more complicated and I'm lazy)
----------------
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    -- Clone packer and install
    api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path..' --depth=1')
end
-- Load Packer
vim.cmd [[packadd packer.nvim]]
-- Load Plugins
----------------
require("packer").startup(function()
    -- Packer can manage itself as an optional plugin
    use {"wbthomason/packer.nvim", opt = true}
    -- Language Server Protocol
    --------
    use 'neovim/nvim-lspconfig'
    --Help with the installation of lsps
    use 'williamboman/nvim-lsp-installer'
    -- Testing Plugins
    use 'nvim-lua/plenary.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'antoinemadec/FixCursorHold.nvim'
    use 'nvim-neotest/neotest'
    use 'nvim-neotest/neotest-python'
    use 'tpope/vim-cucumber'
    -- File System and Plugins
    use {'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons', }, }
    use 'yggdroot/indentline'
    use 'tpope/vim-fugitive'
    use 'editorconfig/editorconfig-vim'
    use 'plasticboy/vim-markdown'
    -- Colors and Themes
    ------------
    use {'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use 'altercation/vim-colors-solarized'
    use 'nvie/vim-flake8'
    -- DevIcons
    use 'kyazdani42/nvim-web-devicons'
    -- Theme
    use 'ii14/onedark.nvim'
    use 'luochen1990/rainbow'
    use 'mechatroner/rainbow_csv'
    -- Languages 
    ------------
    use 'itchyny/vim-gitbranch'
    use 'ekalinin/Dockerfile.vim'
    use 'rust-lang/rust.vim'
    use 'sheerun/vim-polyglot'
    use 'arzg/vim-rust-syntax-ext'
    use 'chrisbra/csv.vim'
    -- Dart/Flutter
    use 'dart-lang/dart-vim-plugin'
    use 'thosakwe/vim-flutter'
    -- Snippets
    ------------
    use "L3MON4D3/LuaSnip"
    -- Alignment
    use 'junegunn/vim-easy-align'
    -- HardMode
    use 'takac/vim-hardtime'
    -- Autocompletion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    -- Database Workbench
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-ui'
    -- Working with Kitty
    use {"fladson/vim-kitty", branch = "main"}
    -- Nvim Repl
    use 'hkupty/iron.nvim'
    -- Nvim Telescope
    use 'nvim-telescope/telescope.nvim'
    -- End of Plugins
    end)

-- Sync Plugins via Alias
------------------
cmd 'cabbrev PackUpdate lua require("packer").sync()'

----------------

--------------------------------
-- Configure Vimrc from Vim
--------------------------------
cmd 'cabbrev editvim e ~/.config/nvim/init.lua'
cmd 'cabbrev updatevim source ~/.config/nvim/init.lua'

--------------------------------
-- General Options Setting
--------------------------------
-- Line Numbers On
opt.number = true

-- Other Enconding and Formatting settings
opt.linebreak = true
opt.autoindent = true
opt.foldenable = false
opt.encoding = 'UTF-8'
opt.showmode = false
opt.splitbelow = true

-- Default Tabstop & Shiftwidth
opt.tabstop= 4
opt.shiftwidth = 4
opt.expandtab = true

--------------------------------
-- Color Scheme Options
--------------------------------
opt.termguicolors = true
cmd 'colorscheme onedark'
-- Rainbow Brackets Options
g['rainbow_active']=1
 
-- Load Webdevicons
require'nvim-web-devicons'.setup { default = true }
require'nvim-web-devicons'.get_icons()
 
-- Status Line Updates
opt.laststatus = 2

----------------
 
----------------------------------
-- Terminal Settings
----------------------------------
-- VSCode Terminal Behaviour
------
-- Terminal Alias and Keyboard Settings
cmd 'cabbrev bterm below new<CR>:terminal'
-- Open Terminal if Terminal has previously been opened then open the
-- previously opened Terminal
-- function TerminalBufferNumbers()
--     return filter(map(getbufinfo(), 'v:val.bufnr'), 'getbufvar(v:val,"&buftype") is# "terminal"')
-- endfunction
-- nmap <silent><expr><leader>t empty(TerminalBufferNumbers())  ? 
--             \ ':bterm<CR><c-\><c-n>:res-10<CR>icls && cd ' . g:cwd . '<CR>' : 
--             \ ':let ntbn = TerminalBufferNumbers()[0]<CR>:exe "sbuffer".ntbn<CR>:res-10<CR>i' 
-- Hide Terminal
map("t", "<silent><leader>t", "<c-\\><c-n>:q<CR>", { silent = true })
-- Exit Terminal Completely
map("t", "<silent><leader>q", "exit<CR><CR>", { silent = true })
 
-- Get rid of terminal line numbers
--------
api.nvim_create_autocmd({ "TermOpen" }, { pattern = { "*" }, command = "setlocal nonumber norelativenumber" })

----------------
 
-------------------------------"
-- Language Specific Settings
-------------------------------"
-- Filetype Enable
cmd 'filetype on'
cmd 'filetype plugin indent on'

-- C++ Language 
cmd 'au FileType cpp setlocal et ts=2 sw=2'

-- HCL Language
cmd 'au BufRead,BufNewFile *.hcl set filetype=ini'

-- JenkinsFile
cmd 'au BufNewFile,BufRead Jenkinsfile set filetype=groovy'

-- Python Language
cmd 'au FileType python setlocal et ts=4 sw=4 sts=4'

-- Typescript Settings
cmd 'au FileType typescript setlocal ts=2 sw=2 sts=2'

-- Vagrant Files
cmd 'au BufRead,BufNewFile Vagrantfile set filetype=ruby'

-- Markdown
---------
cmd 'au FileType markdown setlocal ts=2 sw=2 sts=2'
cmd 'au FileType markdown setlocal spell spelllang=en_gb'
cmd 'au FileType markdown inoremap <TAB> <C-t>'
-- Markdown Syntax Highlighting
g['vim_markdown_fenced_languages'] = [['csharp=cs', 'json=javascript']]
g['vim_markdown_folding_disabled'] = 1
g['vim_markdown_conceal_code_blocks'] = 0
g['vim_markdown_conceal'] = 0
-- Set .draft files to Markdown
cmd 'au BufRead,BufNewFile *.draft set filetype=markdown'

----------------
 
----------------------------------
-- General  Mappings
----------------------------------
 
-- When the enter key is pressed it takes away the highlighting in from the
-- last text search
map("n", "<cr>", ":nohlsearch<CR>", { silent = true })
map("n", "n", ":set hlsearch<CR>n", {silent = true })
map("n", "N", ":set hlsearch<CR>N", {silent = true })

-- Remap Visual and Insert mode to use Normal Modes Tab Rules
--------
map("i", ">>", "<c-t>", {})
map("i", "<<", "<c-d>", {})
 
-- Map Movement Keys to Ctrl hjlk in Terminal, and Command Modes
--------
map("t", "<c-h>", "<Left>", {})
map("t", "<c-h>", "<Left>", {})
map("t", "<c-j>", "<Down>", {})
map("t", "<c-k>", "<Up>", {})
map("c", "<c-l>", "<Right>", {})
map("c", "<c-j>", "<Down>", {})
map("c", "<c-k>", "<Up>", {})
map("c", "<c-l>", "<Right>", {})
 
-- Tab Control
---------
-- Navigation
map("", "<C-t>k", ":tabr<cr>", {})
map("", "<C-t>j", ":tabl<cr>", {})
map("", "<C-t>l", ":tabn<cr>", {})
map("", "<C-t>h", ":tabp<cr>", {})
-- Close Current Tab
map("", "<C-t>c", ":tabc<cr>", {})
-- Close all other Tabs
map("", "<C-t>o", ":tabo<cr>", {})
-- New Tab - note n is already used as a search text tool and cannot be mapped
map("", "<C-t><c-n>", ":tabnew<cr>", {})

-- Tmux Pane Resizing
---------
-- Terminal
map("t", "<c-a><c-j>", "<c-\\><c-n>:res-5<CR>i", {})
map("t", "<c-a><c-k>", "<c-\\><c-n>:res+5<CR>i", {})
map("t", "<c-a><c-h>", "<c-\\><c-n>:vertical resize -5<CR>i", {})
map("t", "<c-a><c-l>", "<c-\\><c-n>:vertical resize +5<CR>i", {})
-- Insert
map("i", "<c-a><c-j>", ":res-5<CR>", {})
map("i", "<c-a><c-k>", ":res+5<CR>", {})
map("i", "<c-a><c-h>", "<c-\\><c-n>:vertical resize -5<CR>i", {})
map("i", "<c-a><c-l>", "<c-\\><c-n>:vertical resize +5<CR>i", {})
-- Command
map("c", "<c-a><c-j>", ":res-5<CR>", {})
map("c", "<c-a><c-k>", ":res+5<CR>", {})
map("c", "<c-a><c-h>", "<c-\\><c-n>:vertical resize -5<CR>i", {})
map("c", "<c-a><c-l>", "<c-\\><c-n>:vertical resize +5<CR>i", {})
-- Normal
map("n", "<c-a><c-j>", ":res-5<CR>", {})
map("n", "<c-a><c-k>", ":res+5<CR>", {})
map("n", "<c-a><c-h>", "<c-\\><c-n>:vertical resize -5<CR>i", {})
map("n", "<c-a><c-l>", "<c-\\><c-n>:vertical resize +5<CR>i", {})
 
-- Buffer Switch & Delete
---------
-- Buffer Switch
map("n", "<c-b>s", ":ls<CR>:b<Space>", {})
-- Buffer Delete, note: can only delete one buffer at a time
map("n", "<c-b>d", ":ls<CR>:bd<Space>", {})
-- Terminal Commands, autoswitch focussed pane and then change buffer 
-- assumes the terminal is horizontally split and on the bottom
map("t", "<c-b>s", "<c-w>k :ls<CR>:b<Space>", {})
-- Buffer Delete, note: can only delete one buffer at a time
map("t", "<c-b>d", "<c-w>k :ls<CR>:bd<Space>", {})

----------------
 
---------------------------------"
-- Custom Commands
---------------------------------"

-- Jira Csv 
---------
-- function! MakeJira()
--     set filetype=csv
--     normal iProject,Summary,Issue Type,Issue Key,Description,Acceptance Criteria,Lables,Story Link
-- endfunction

-- command Jiracsv :call MakeJira()

-----------------------------------------"
-- Leader Remappings, Plugin Commands
-----------------------------------------"
-- Note: I often will use <leader> remappings as a way to distinguish between
-- plugins in order to segregate commands.
-- This follows the conventions <leader>{plugin key}{command key}
-- I've listed already use leader commands here
-- Telescope Nvim: <leader>f
-- Database - DadBod: : <leader>d
-- Snippets - UltiSnips : <leader>s
-- Terminal : <leader>t & <leader> q
-- Testing - Ultest : <leader>x (T is being used for the terminal)
-- Code Alignment - EasyAlign : <leader>e
-- REPL - Iron.nvim: <leader>r
-- AutoComplete and Diagnostics - coc.nvim: <leader>c

---------------------------------"
-- UltiSnips Options
---------------------------------"
-- Load LuaSnip
local ls = require("luasnip")

---------

-----------------------------
-- NvimTree Options 
-----------------------------

require("nvim-tree").setup {
  auto_reload_on_write = true,
  create_in_closed_folder = false,
  hijack_cursor = true,
  hijack_netrw = true,
  sort_by = "name",
  root_dirs = {},
  sync_root_with_cwd = true,
  view = {
   adaptive_size = true,
   centralize_selection = false,
   width = 50,
   height = 30,
   side = "right",
   relativenumber = true,
   signcolumn = "yes",
   mappings = {
    custom_only = false,
    list = { 
              { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
              { key = "<C-e>", action = "edit_in_place" },
              { key = "O", action = "edit_no_picker" },
              { key = { "<C-]>", "<2-RightMouse>" }, action = "cd" },
              { key = "<C-v>", action = "vsplit" },
              { key = "<C-x>", action = "split" },
              { key = "<C-t>", action = "tabnew" },
              { key = "<", action = "prev_sibling" },
              { key = ">", action = "next_sibling" },
              { key = "P", action = "parent_node" },
              { key = "<BS>", action = "close_node" },
              { key = "<Tab>", action = "preview" },
              { key = "K", action = "first_sibling" },
              { key = "J", action = "last_sibling" },
              { key = "I", action = "toggle_git_ignored" },
              { key = "H", action = "toggle_dotfiles" },
              { key = "U", action = "toggle_custom" },
              { key = "R", action = "refresh" },
              { key = "a", action = "create" },
              { key = "d", action = "remove" },
              { key = "D", action = "trash" },
              { key = "r", action = "rename" },
              { key = "<C-r>", action = "full_rename" },
              { key = "x", action = "cut" },
              { key = "c", action = "copy" },
              { key = "p", action = "paste" },
              { key = "y", action = "copy_name" },
              { key = "Y", action = "copy_path" },
              { key = "gy", action = "copy_absolute_path" },
              { key = "[e", action = "prev_diag_item" },
              { key = "[c", action = "prev_git_item" },
              { key = "]e", action = "next_diag_item" },
              { key = "]c", action = "next_git_item" },
              { key = "-", action = "dir_up" },
              { key = "s", action = "system_open" },
              { key = "f", action = "live_filter" },
              { key = "F", action = "clear_live_filter" },
              { key = "q", action = "close" },
              { key = "W", action = "collapse_all" },
              { key = "E", action = "expand_all" },
              { key = "S", action = "search_node" },
              { key = ".", action = "run_file_command" },
              { key = "<C-k>", action = "toggle_file_info" },
              { key = "g?", action = "toggle_help" },
              { key = "m", action = "toggle_mark" },
              { key = "bmv", action = "bulk_move" },
          }
    },
    renderer = {
      highlight_git = true,
      full_name = false,
      root_folder_modifier = ":~",
      indent_markers = {
        enable = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          none = " ",
        },
      },
    },
    diagnostics = {
      enable = true,
    },
    filters = {
      dotfiles = true,
    },
    git = {
      enable = true,
      ignore = true,
      show_on_dirs = true,
      timeout = 400,
    },
    actions = {
      open_file = {
        quit_on_open = false,
        resize_window = true,
        window_picker = {
          enable = true,
        },
      },
      remove_file = {
        close_window = true,
      },
    },
  }
}
-- NvimTree Git Plugin Symbols
-- make sure relative line numbers are used
cmd 'autocmd FileType NvimTree setlocal relativenumber'

-- Mappings
----------
-- Remap the open and close to C-n
map("n", "<C-n>", ":NvimTreeToggle<CR>", {})
-- Terminal Commands, autoswitch focussed pane and then switch to nerdtree,
-- assumes the terminal is horizontally split and on the bottom
map("t", "<C-n>", "<C-\\><C-n><c-w>k :NvimTreeToggle<CR>", {})

-----------------

-----------------------------
-- LuaLine Configuration
-----------------------------
require("lualine").setup()

-- DevIcon FileType
-- function! DeviconsFileType()
--     return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
-- endfunction

-- DevIcon FileFormat
-- function! DeviconsFileFormat()
--     return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
-- endfunction

-- Turn Filename Into FilePath
-- function! LightlineTruncatedFileName()
--     let l:filePath = expand('%')
--     return winwidth(0) > 100 ? l:filePath : pathshorten(l:filePath)
-- endfunction

-- Shorten Branch Name If Necessary
-- function! LightlineGitBranchName()
--     let l:gitbranch = gitbranch#name()
--     return winwidth(0) > 100 ? l:gitbranch : join(split(l:gitbranch, "-")[-3:], "-")
-- endfunction

-- function! LightlineVirtualEnv()
--     if ($VIRTUAL_ENV != "")
--         let l:virtualenv = split($VIRTUAL_ENV,"/")[-1:][0]
--     else
--         let l:virtualenv = ""
--     endif
--     return l:virtualenv
-- endfunction


-- Configuration
-- let g:lightline = { 'mode_map' : { 'n':'N', 'i':'I','R':'R', 'vb':'V', 'V':'VL', "\<C-v>":'VB', 't':'T', 'c':'X' }, 'colorscheme': 'Tomorrow_Night', 'active': { 'left': [ [ 'mode', 'paste' ], [ 'virtualenv', 'gitbranch', 'filename' ]], 'right': [ [ 'lineinfo' ], [ 'filetype', 'fileencoding' ] ]  }, 'component_function': { 'filename': 'LightlineTruncatedFileName', 'gitbranch': 'LightlineGitBranchName', 'filetype': 'DeviconsFileType', 'fileformat': 'DeviconsFileFormat', 'virtualenv': 'LightlineVirtualEnv' }, }

---------------------------------"
-- Telescope Settings (Neovim Only)
---------------------------------"
 
-- Find files using Telescope command-line sugar.
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { silent = true })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { silent = true })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { silent = true })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { silent = true })

----------------

---------------------------------"
-- Easy Align
---------------------------------"

-- Start interactive EasyAlign in visual mode (e.g. vipga)
map("x", "<leader>e", "<Plug>(EasyAlign)<CR>", {})
 
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
map("n", "<leader>e", "<Plug>(EasyAlign)<CR>", {})
 
---------------
 
---------------------------------"
-- Database Commands - DadBod
---------------------------------"

-- Options
---------
g['db_ui_save_location'] = '~/.config/db_ui'
g['dd_ui_use_nerd_fonts'] = 1

-- Mappings
---------
map("n", "<leader>du", ":DBUIToggle<CR>", { silent = true })
map("n", "<leader>df", ":DBUIFindBuffer<CR>", { silent = true })
map("n", "<leader>dr", ":DBUIRenameBuffer<CR>", {silent = true })
map("n", "<leader>dl", ":DBUILastQueryInfo<CR>", {silent = true })

----------------

---------------------------------"
-- REPL - Iron.nvim
---------------------------------"
iron = require("iron.core")
iron.setup {
    -- Options
    ---------
    config = {
        should_map_plug = false,
        scratch_repl = true,
        repl_definition = {
            sh = { command = { "bash" } },
            python = { command  = { "python3" } },
            scala = { command  = { "scala" } },
            lua = { command = { "lua" } }
        },
        repl_open_cmd = require('iron.view').curry.right(40),
     },
    -- Mappings
    ---------
    keymaps = {
      send_motion = "<Leader>rs",
      visual_send = "<Leader>rs",
      send_file = "<Leader>rf",
      send_line = "<Leader>rl",
      send_mark = "<Leader>rm",
      mark_motion = "<Leader>rmm",
      mark_visual = "<Leader>rmm",
      remove_mark = "<Leader>rmd",
      cr = "<Leader>r<cr>",
      interrupt = "<Leader>rx",
      exit = "<Leader>rq",
      clear = "<Leader>rl",
    },
}

-- Mappings
---------
map("n", "<leader>ro", ":IronRepl<CR>", { silent = true })

----------------

---------------------------------"
-- Editor Config Commands
---------------------------------"

-- let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
-- au FileType gitcommit let b:EditorConfig_disable = 1

---------------------------------"
-- Coc-Options Load
---------------------------------"
-- au BufRead,BufNewFile .cocrc set filetype=vim
-- let g:cochome = $HOME . '/.vim/.cocrc'
-- if filereadable(cochome)
--     exec 'source' . cochome
--     cabbrev editcoc execute 'e' g:cochome
--     cabbrev updatecoc execute 'source' g:cochome
-- endif

-- Allow WorkSpace Specific RCs
-- if filereadable("./vimwsrc")
--     source ./vimwsrc
-- endif

-- Use Deoplete for Intellij Sync
---------
-- let g:deoplete#enable_at_startup=1

-----------------------END OF VIMRC--------------------- "
