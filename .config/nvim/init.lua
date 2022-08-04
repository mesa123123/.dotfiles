--------------------------
-- ###################  --
-- # Main Vim Config #  --
-- ###################  --
--------------------------

--------------------------------
-- TO DO
--------------------------------
-- 1. Learn LuaSnip
--      a. Rewrite Snippets for Lua
--      b. Restructure Snippets so only that format of Snippets loads
-- 2. Figure out how to run telescope
-- 4. Make the modes on LuaLine Single Char
----------------------------------

-------------------------------
-- Priority Settings
--------------------------------
-- Set the config path
vim.g["config_path"] = "~/config/nvim"
-- Set the mapleader
vim.g["mapleader"] = "\\"

--------------------------------
-- Luaisms for Vim Stuff
--------------------------------

-- Variables
----------
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local keymap = vim.keymap
local g = vim.g -- global variables
local opt = vim.opt -- vim options
local gopt = vim.o -- global options
local bopt = vim.bo -- buffer options
local wopt = vim.wo -- window options

-- Functions
--------

-- ex (Currenly this is a wrapper for everything not yet implemented in nvim)
----------
local ex = setmetatable({}, {
    __index = function(t, k)
      local command = k:gsub("_$", "!")
      local f = function(...)
        return api.nvim_command(table.concat(vim.tbl_flatten {command, ...}, " "))
      end
      rawset(t, k, f)
      return f
    end
  });

-- Map(function, table)
function Map(func, tbl)
    local newtbl = {}
    for i, v in pairs(tbl) do
        newtbl[i] = func(v)
    end
    return newtbl
end

----------

-- Filter(function, table)
function Filter(func, tbl)
    local newtbl = {}
    for i, v in pairs(tbl) do
        if func(v) then
            newtbl[i] = v
        end
    end
    return newtbl
end

----------------


--------------------------------
-- Plugin Loading and Settings
--------------------------------
-- Install Packer and Sync if required (vim-plug was going to be more complicated and I'm lazy)
----------------
local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    -- Clone packer and install
    api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path .. ' --depth=1')
end
-- Load Packer
cmd [[packadd packer.nvim]]
-- Load Plugins
----------------
require("packer").startup(function()
    -- Packer can manage itself as an optional plugin
    use { "wbthomason/packer.nvim", opt = true }
    -- Autocompletion
    ----------
    use { 'hrsh7th/nvim-cmp',
        -- Extensions for NvimCmp
        requires = {
            use 'hrsh7th/cmp-nvim-lsp',
            use 'saadparwaiz1/cmp_luasnip',
            use 'hrsh7th/cmp-path',
            use 'hrsh7th/cmp-buffer',
            use 'hrsh7th/cmp-nvim-lua',
            use 'hrsh7th/cmp-cmdline',
            use 'ray-x/cmp-treesitter',
            use 'L3MON4D3/LuaSnip',
            use 'rcarriga/nvim-notify',
        }
    }
    -- Language Server Protocol
    ----------
    use { 'neovim/nvim-lspconfig',
        wants = { "nvim-cmp", "mason.nvim", "mason-lspconfig.nvim", "lsp_signature.nvim" },
        requires = { 'williamboman/mason-lspconfig.nvim', 'williamboman/mason.nvim', 'ray-x/lsp_signature.nvim',
            'hrsh7th/nvim-cmp', 'L3MON4D3/LuaSnip' }, }
    use { 'jose-elias-alvarez/null-ls.nvim', branch = 'main' }
    -- Debug Adapter Protocol
    ----------
    use 'mfussenegger/nvim-dap'
    -- Testing Plugins
    ----------
    use 'nvim-lua/plenary.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'antoinemadec/FixCursorHold.nvim'
    use 'nvim-neotest/neotest'
    use 'nvim-neotest/neotest-python'
    use 'tpope/vim-cucumber'
    -- File System and Plugins
    ----------
    use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons', }, }
    use 'yggdroot/indentline'
    use 'tpope/vim-fugitive'
    use 'editorconfig/editorconfig-vim'
    use 'plasticboy/vim-markdown'
    -- Colors and Themes
    ------------
    use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use 'altercation/vim-colors-solarized'
    use 'nvie/vim-flake8'
    -- DevIcons
    use 'kyazdani42/nvim-web-devicons'
    -- Theme
    use 'ii14/onedark.nvim'
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
    -- Alignment
    use 'junegunn/vim-easy-align'
    -- HardMode
    use 'takac/vim-hardtime'
    -- Database Workbench
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-ui'
    -- Working with Kitty
    use { "fladson/vim-kitty", branch = "main" }
    -- Nvim Repl
    use 'hkupty/iron.nvim'
    -- Terminal Behaviour
    use { 'akinsho/toggleterm.nvim', tag = 'v2.*' }
    -- Nvim Telescope
    use { 'nvim-telescope/telescope.nvim', requires = { "BurntSushi/ripgrep", "sharkdp/fd", opt = false }, }
    -- End of Plugins
end)

-- Sync Plugins via Alias
------------------
api.nvim_create_user_command('PackUpdate', 'lua require("packer").sync()', {})
------------------

--------------------------------
-- Configure Vimrc from Vim
--------------------------------

-- Commands
----------
api.nvim_create_user_command('Editvim', 'e ~/.config/nvim/init.lua', {}) -- Edit Config
api.nvim_create_user_command('Srcv', 'luafile ~/.config/nvim/init.lua', {}) -- Source Config
----------

--------------------------------
-- Color Schemes and Themes
--------------------------------

-- Dealing with Mac Colors
----------
if fn.has('macunix')
then
    opt.termguicolors = false
else
    opt.termguicolors = true
end
----------

-- Load Color Scheme
----------
cmd [[ colorscheme onedark ]]
----------

-- Rainbow Brackets Options
----------
g['rainbow_active'] = 1
----------

-- Load Webdevicons
----------
require 'nvim-web-devicons'.setup { default = true }
require 'nvim-web-devicons'.get_icons()
----------

-- Status Line Settings
----------
opt.laststatus = 2
----------

--------------------------------
-- Editor Options, Settings, Commands
--------------------------------

-- Options
----------
-- Line Numbers On
opt.number = true
-- Other Enconding and Formatting settings
opt.linebreak = true
opt.autoindent = true
opt.foldenable = false
opt.encoding = 'UTF-8'
opt.showmode = false
opt.splitbelow = true
opt.signcolumn = 'yes'
-- Default Tabstop & Shiftwidth
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
----------

-- Settings
----------
g['EditorConfig_exclude_patterns'] = { 'fugitive://.*', 'scp://.*' }
----------

-- Commands
----------
cmd [[ au FileType gitcommit let b:EditorConfig_disable = 1 ]]
----------

-------------------------------"
-- Language Specific Settings
-------------------------------"

-- Filetype Enable
-----------
cmd [[ filetype on ]]
cmd [[ filetype plugin indent on ]]
----------

-- FileTypes
----------
cmd [[ au FileType cpp setlocal et ts=2 sw=2 ]] -- C++ Language 
cmd [[ au BufRead,BufNewFile *.hcl set filetype=ini ]] -- HCL Language
cmd [[ au BufNewFile,BufRead Jenkinsfile set filetype=groovy ]] -- JenkinsFile
cmd [[ au FileType python setlocal et ts=4 sw=4 sts=4 ]] -- Python Language
cmd [[ au FileType typescript setlocal ts=2 sw=2 sts=2 ]] -- Typescript Settings
cmd [[ au BufRead,BufNewFile Vagrantfile set filetype=ruby ]] -- Vagrant Files
----------

-- Markdown
---------
cmd [[ au FileType markdown setlocal ts=2 sw=2 sts=2 ]]
cmd [[ au FileType markdown setlocal spell spelllang=en_gb ]]
cmd [[ au FileType markdown inoremap <TAB> <C-t> ]]
-- Markdown Syntax Highlighting
g['vim_markdown_fenced_languages'] = [['csharp=cs', 'json=javascript']]
g['vim_markdown_folding_disabled'] = 1
g['vim_markdown_conceal_code_blocks'] = 0
g['vim_markdown_conceal'] = 0
-- Set .draft files to Markdown
cmd [[ au BufRead,BufNewFile *.draft set filetype=markdown ]]
----------

-- GitCommit
----------
g['EditorConfig_exclude_patterns'] = { 'fugitive://.*', 'scp://.*' }
cmd [[ au FileType gitcommit let b:EditorConfig_disable = 1 ]]
----------

----------------------------------
-- Editor Mappings
----------------------------------

-- Set Write/Quit to shortcuts
---------
keymap.set('n', '<leader>ww', ':w<CR>', { silent = false, noremap = true })
keymap.set('n', '<leader>ws', ':source %<CR>', { silent = false, noremap = true })
keymap.set('n', '<leader>wqq', ':wq<CR>', { silent = false, noremap = true })
keymap.set('n', '<leader>wqa', ':wqa<CR>', { silent = false, noremap = true })
keymap.set('n', '<leader>wa', ':wa<CR>', { silent = false, noremap = true })
keymap.set('n', '<leader>qa', ':qa<CR>', { silent = false, noremap = true })
keymap.set('n', '<leader>qq', ':q<CR>', { silent = false, noremap = true })
keymap.set('n', '<leader>q!', ':q!<CR>', { silent = false, noremap = true })
----------

-- When the enter key is pressed it takes away the highlighting in from the last text search
----------
keymap.set("n", "<cr>", ":nohlsearch<CR>", { silent = true })
keymap.set("n", "n", ":set hlsearch<CR>n", { silent = true })
keymap.set("n", "N", ":set hlsearch<CR>N", { silent = true })
----------

-- Remap Visual and Insert mode to use Normal Modes Tab Rules
----------
keymap.set("i", ">>", "<c-t>", {})
keymap.set("i", "<<", "<c-d>", {})
----------

-- Map Movement Keys to Ctrl hjlk in Terminal, and Command Modes
----------
keymap.set("t", "<c-h>", "<Left>", {})
keymap.set("t", "<c-h>", "<Left>", {})
keymap.set("t", "<c-j>", "<Down>", {})
keymap.set("t", "<c-k>", "<Up>", {})
keymap.set("c", "<c-l>", "<Right>", {})
keymap.set("c", "<c-j>", "<Down>", {})
keymap.set("c", "<c-k>", "<Up>", {})
keymap.set("c", "<c-l>", "<Right>", {})
----------

-- Tab Control
---------
-- Navigation
keymap.set("", "<C-t>k", ":tabr<cr>", {})
keymap.set("", "<C-t>j", ":tabl<cr>", {})
keymap.set("", "<C-t>l", ":tabn<cr>", {})
keymap.set("", "<C-t>h", ":tabp<cr>", {})
-- Close Current Tab
keymap.set("", "<C-t>c", ":tabc<cr>", {})
-- Close all other Tabs
keymap.set("", "<C-t>o", ":tabo<cr>", {})
-- New Tab - note n is already used as a search text tool and cannot be mapped
keymap.set("", "<C-t><c-n>", ":tabnew<cr>", {})
----------

-- Tmux Pane Resizing
---------
-- Terminal
keymap.set("t", "<c-a><c-j>", "<c-\\><c-n>:res-5<CR>i", {})
keymap.set("t", "<c-a><c-k>", "<c-\\><c-n>:res+5<CR>i", {})
keymap.set("t", "<c-a><c-h>", "<c-\\><c-n>:vertical resize -5<CR>i", {})
keymap.set("t", "<c-a><c-l>", "<c-\\><c-n>:vertical resize +5<CR>i", {})
-- Insert
keymap.set("i", "<c-a><c-j>", ":res-5<CR>", {})
keymap.set("i", "<c-a><c-k>", ":res+5<CR>", {})
keymap.set("i", "<c-a><c-h>", "<c-\\><c-n>:vertical resize -5<CR>i", {})
keymap.set("i", "<c-a><c-l>", "<c-\\><c-n>:vertical resize +5<CR>i", {})
-- Command
keymap.set("c", "<c-a><c-j>", ":res-5<CR>", {})
keymap.set("c", "<c-a><c-k>", ":res+5<CR>", {})
keymap.set("c", "<c-a><c-h>", "<c-\\><c-n>:vertical resize -5<CR>i", {})
keymap.set("c", "<c-a><c-l>", "<c-\\><c-n>:vertical resize +5<CR>i", {})
-- Normal
keymap.set("n", "<c-a><c-j>", ":res-5<CR>", {})
keymap.set("n", "<c-a><c-k>", ":res+5<CR>", {})
keymap.set("n", "<c-a><c-h>", "<c-\\><c-n>:vertical resize -5<CR>i", {})
keymap.set("n", "<c-a><c-l>", "<c-\\><c-n>:vertical resize +5<CR>i", {})
----------

-----------------------------------------
-- Leader Remappings, Plugin Commands
-----------------------------------------

-- Note
----------
-- I'll use leader mappings for plugins and super extra goodies
-- however ones I use all the time will be mapped to `<c-` or a specific key
-- This follows the conventions <leader>{plugin key}{command key}
-- I've listed already use leader commands here
----------

-- Mappings
----------
-- Write Commands: <leader>w
-- Quit Commands: <leader>q
-- Terminal - TerminalToggle : <leader>t & <leader> q
-- Snippets - LuaSnip : <leader>s
-- Filetree - NvimTree : <c-n>
-- Buffer Management - Telescope Nvim: <leader>f
-- Database - DadBod: : <leader>d
-- Testing - Ultest : <leader>x (T is being used for the terminal)
-- Code Alignment - EasyAlign : <leader>e
-- REPL - Iron.nvim: <leader>r
-- AutoComplete and Diagnostics - NvimCmp (and dependents): <leader>c & g
----------

----------------------------------
-- Terminal Settings
----------------------------------

require("toggleterm").setup {
    -- Options
    ----------
    open_mapping = '<Leader>t',
    direction = 'float',
    persist_mode = true,
    close_on_exit = true,
    terminal_mappings = true,
    hide_numbers = true,
    on_open = function()
        cmd [[ TermExec cmd="source ~/.bash_profile &&  clear" ]]
    end,
    on_exit = function()
        cmd [[silent! ! unset HIGHER_TERM_CALLED ]]
    end
}

-- Mappings
----------
keymap.set("t", "<leader>q", "<CR>exit<CR><CR>", { noremap = true, silent = true }) -- Send exit command
keymap.set("t", "<Esc>", "<c-\\><c-n>", { noremap = true, silent = true }) -- Use Esc to change modes in the terminal
keymap.set("t", "vim", "say \"You're already in vim! You're a dumb ass!\"", { noremap = true, silent = true })
keymap.set("t", "editvim", "say \"You're already in vim! This is why no one loves you!\"", { noremap = true, silent = true })

----------

-----------------------------
-- Filetree Options - NvimTree
-----------------------------

require("nvim-tree").setup {
    -- Options 1
    ----------
    auto_reload_on_write = true,
    create_in_closed_folder = true,
    hijack_cursor = true,
    hijack_netrw = true,
    sort_by = "name",
    sync_root_with_cwd = true,
    view = {
        adaptive_size = true,
        centralize_selection = false,
        width = 50,
        height = 30,
        side = "right",
        relativenumber = true,
        signcolumn = "yes",
        -- Mappings
        ----------
        mappings = {
            custom_only = false,
            list = {
                { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
                { key = "<S-CR>", action = "edit_in_place" },
                { key = "O", action = "edit_no_picker" },
                { key = { "l", "<2-RightMouse>" }, action = "cd" },
                { key = "<C-v>", action = "vsplit" },
                { key = "<C-x>", action = "split" },
                { key = "<C-t>", action = "tabnew" },
                { key = "<", action = "prev_sibling" },
                { key = ">", action = "next_sibling" },
                { key = "P", action = "parent_node" },
                { key = "<BS>", action = "close_node" },
                { key = "<Tab>", action = "preview" },
                { key = "I", action = "toggle_git_ignored" },
                { key = "H", action = "toggle_dotfiles" },
                { key = "U", action = "toggle_custom" },
                { key = "r", action = "refresh" },
                { key = "ma", action = "create" },
                { key = "md", action = "remove" },
                { key = "mD", action = "trash" },
                { key = "mm", action = "rename" },
                { key = "mM", action = "full_rename" },
                { key = "mx", action = "cut" },
                { key = "mc", action = "copy" },
                { key = "mp", action = "paste" },
                { key = "my", action = "copy_name" },
                { key = "mYr", action = "copy_path" },
                { key = "mYa", action = "copy_absolute_path" },
                { key = "[s", action = "prev_diag_item" },
                { key = "[g", action = "prev_git_item" },
                { key = "]s", action = "next_diag_item" },
                { key = "]g", action = "next_git_item" },
                { key = "h", action = "dir_up" },
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
                { key = "mtm", action = "toggle_mark" },
                { key = "mbm", action = "bulk_move" },
            },
        },
    },
    -- Options 2
    ----------
    renderer = {
        highlight_git = true,
        full_name = false,
        root_folder_modifier = ":~",
    },
    diagnostics = {
        enable = true,
    },
    filters = {
        dotfiles = true,
    },
    git = {
        enable = true,
        ignore = false,
    },
    actions = {
        open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
                enable = true,
            },
        },
    },
}
----------

-- NvimTree Git Plugin Symbols
----------
cmd [[ autocmd FileType NvimTree setlocal relativenumber ]] -- make sure relative line numbers are used
----------

-- Mappings
----------
keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", {}) -- Remap the open and close to C-n
-- Terminal Commands, autoswitch focussed pane and then switch to nerdtree,
keymap.set("t", "<C-n>", "<C-\\><C-n><c-w>k :NvimTreeToggle<CR>", {}) -- assumes the terminal is horizontally split and on the bottom
-----------------

-----------------------------
-- LuaLine Configuration
-----------------------------

-- Config
----------
require("lualine").setup({
    options = {
        section_separators = { left = '|', right = '|' },
        component_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = { { 'mode', fmt = function (res) return res:sub(1,1) end } },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { "os.date('%H:%M %Y-%m-%d')" },
        lualine_z = { 'progress', 'location',  }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    }
})
----------

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


---------------------------------
-- Telescope Settings
---------------------------------

-- Find files using Telescope command-line sugar.
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { silent = true })
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { silent = true })
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { silent = true })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { silent = true })
keymap.set("n", "<C-b>s", "<cmd>Telescope buffers<cr>", { silent = true, noremap = true })
----------------


---------------------------------
-- Easy Align
---------------------------------

-- Start interactive EasyAlign in visual mode (e.g. vipga)
keymap.set("x", "<leader>e", "<Plug>(EasyAlign)<CR>", {})

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
keymap.set("n", "<leader>e", "<Plug>(EasyAlign)<CR>", {})

---------------

---------------------------------"
-- Database Commands - DadBod
---------------------------------"

-- Options
---------
g['db_ui_save_location'] = '~/.config/db_ui'
g['dd_ui_use_nerd_fonts'] = 1
----------

-- Mappings
---------
keymap.set("n", "<leader>du", ":DBUIToggle<CR>", { silent = true })
keymap.set("n", "<leader>df", ":DBUIFindBuffer<CR>", { silent = true })
keymap.set("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { silent = true })
keymap.set("n", "<leader>dl", ":DBUILastQueryInfo<CR>", { silent = true })
----------------

---------------------------------"
-- REPL - Iron.nvim
---------------------------------"

require("iron.core").setup {
    -- Options
    ---------
    config = {
        should_map_plug = false,
        scratch_repl = true,
        repl_definition = {
            sh = { command = { "bash" } },
            python = { command = { "python3" } },
            scala = { command = { "scala" } },
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
keymap.set("n", "<leader>ro", ":IronRepl<CR>", { silent = true })
----------

---------------------------------"
-- LSP Config
---------------------------------"

-- Notes
----------
-- All Lsp Settings are configured in nvim/lua/lsp.lua
----------

-- Commands
----------
api.nvim_create_user_command('Editlsp', 'e ~/.config/nvim/lua/lsp.lua', {})
----------

-- Load File
----------
require("lsp")
----------

--------------------------------
-- Workspace Specific Configs
--------------------------------

-- Allow WorkSpace Specific Init
-- if filereadable("./ws_init.lua")
--     luafile ./ws_init.lua
-- endif

--------------------------------
-- EOF
--------------------------------
