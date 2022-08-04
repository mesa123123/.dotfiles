" --------------------------------"
" Priority Settings
" --------------------------------"
" Set No Compatible allows Coc to work for some weird reason?
set nocompatible
" set the current directory to a variable
let g:cwd = getcwd()
" set the mapleader
let mapleader = "\\"
" Set Coc_Config_Home
let g:coc_config_home = '/home/$USER/.vim/'
" --------------------------------"
" Plugin Loading and Settings
" --------------------------------"

" Load Plugings
" --------
call plug#begin('/home/$USER/.vim/pack/my_plugins/start')
" Testing Plugins
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-python'
Plug 'tpope/vim-cucumber'
" File System and Plugins
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'yggdroot/indentline'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'plasticboy/vim-markdown'
" Colors and Themes
Plug 'itchyny/lightline.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'ryanoasis/vim-webdevicons'
Plug 'nvie/vim-flake8'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'luochen1990/rainbow'
Plug 'mechatroner/rainbow_csv'
" Languages
" --------
Plug 'derekwyatt/vim-scala'
Plug 'itchyny/vim-gitbranch'
Plug 'ekalinin/Dockerfile.vim'
Plug 'rust-lang/rust.vim'
Plug 'sheerun/vim-polyglot'
Plug 'arzg/vim-rust-syntax-ext'
Plug 'chrisbra/csv.vim'
" Dart/Flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
" ----
" Snippets
Plug 'junegunn/vim-easy-align'
Plug 'takac/vim-hardtime'
" AutoComplete Etc.
Plug 'neoclide/coc.nvim'
" Database Workbench
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
" Working with Kitty
Plug 'fladson/vim-kitty', {'branch': 'main'}
"Nvim Repo
Plug 'hkupty/iron.nvim'
" Nvim Telescope
if has('nvim')
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
endif

call plug#end()

" Plugin Settings
" --------
let g:plug_timeout = 120
let g:plug_retries = 5
let g:plug_threads = 32

" ----------------

" Python Config
" --------
" Python Settings
let g:python3_host_prog = '/usr/bin/python3'

" --------------------------------"
" Configure Vimrc from Vim
" --------------------------------"
cabbrev editvim e ~/.vim/.vimrc
cabbrev updatevim source ~/.vim/.vimrc
" ----------------

" --------------------------------"
" Neovim Specific Settings
" --------------------------------"
if has('nvim')
    " remap Esc back to trigger normal mode in terminal 
    tnoremap <Esc> <c-\><c-n>
    " remap the pane movements
    tnoremap <c-w> <c-\><c-n><c-w>
    " remap the tab movements 
    tnoremap <c-t> <c-\><c-n><c-t>
    " point to UltiSnipsHome
    let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
    
endif
" ----------------

" --------------------------------"
" General Options Setting
" --------------------------------"

"  Status Line Always On (This is essentially an enum)
set laststatus=2

" Status Line Updates
set laststatus=2

" Line Numbers On
set nu

" Auto-toggle Hybrid Numbering Based Focus Window
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

"	Tabstop & Shiftwidth
set tabstop=4
set shiftwidth=4
set expandtab

" Language Syntax On
syntax on
let python_highlight_all=1
set linebreak
set autoindent
set nofoldenable
set encoding=UTF-8
set noshowmode

" Split Settings
set splitbelow
set splitright
nnoremap <c-w>v :vnew<CR>

" Set up FileType functionality
filetype on
filetype plugin indent on

" Color Schemes and Themes
" --------

"	Color Scheme Options
if has('macunix')
    set notermguicolors
else 
    set termguicolors
endif

set t_Co=25
colorscheme onehalfdark

"Rainbow Brackets
let g:rainbow_active=1

if exists("g:loaded_webdevicons")
      call webdevicons#refresh()
  endif

" Web Dev Icons Settings
" --------
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

" Hardtime On
let g:hardtime_showing = 1
let g:hardime_allow_different_key = 1
let g:hardtime_showmsg = 1

" Movement
" --------

" Page Scroll Speed ++
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
vnoremap <C-e> 5<C-e>
vnoremap <C-y> 5<C-y>

" Begining & End of line in Normal mode
noremap H ^
noremap L g_

" ----------------

" --------------------------------"
" Terminal Settings
" --------------------------------"
"  VSCode Terminal Behaviour
"  ----
" Terminal Alias and Keyboard Settings
if has('nvim')
    cabbrev bterm below new<CR>:terminal 
else
    cabbrev bterm bo term
endif
" Open Terminal if Terminal has previously been opened then open the
" previously opened Terminal
function TerminalBufferNumbers()
    return filter(map(getbufinfo(), 'v:val.bufnr'), 'getbufvar(v:val,"&buftype") is# "terminal"')
endfunction
nmap <silent><expr><leader>t empty(TerminalBufferNumbers())  ? 
            \ ':bterm<CR><c-\><c-n>:res-10<CR>icls && cd ' . g:cwd . '<CR>' : 
            \ ':let ntbn = TerminalBufferNumbers()[0]<CR>:exe "sbuffer".ntbn<CR>:res-10<CR>i' 
" Hide Terminal
tnoremap <silent><leader>t <c-\><c-n>:q<CR>
" Exit Terminal Completely
if has('nvim')
    tnoremap <silent><leader>q exit<CR><CR>
else
    tnoremap <silent><leader>q exit<CR>
endif

" Get rid of terminal line numbers
" --------
if has('nvim')
    autocmd TermOpen * setlocal nonumber norelativenumber
endif
" ----------------

" ------------------------------"
" Language Specific Settings
" ------------------------------"
function RunMermaidPreview()
    execute '!/home/$USER/dev/projects/vimmermaid/stap.sh &'
endfunction
au BufNewFile,BufRead *.mermaid set filetype=mermaid
au Filetype mermaid call RunMermaidPreview()

" C++ Language 
au FileType cpp setlocal et ts=2 sw=2

" Python Language
let g:pymode_rope = 0
let g:pymode_rope_goto_definition_bind = '<c-c>g'
let g:pymode_rope_goto_definition_cmd = 'new'
let g:pymode_lint = 0
let g:pymode_lint_on_write = 0
let g:pymode_lint_on_fly = 0
au FileType python setlocal et ts=4 sw=4 sts=4

" HCL Language
au BufRead,BufNewFile *.hcl set filetype=ini

" JenkinsFile
au BufNewFile,BufRead Jenkinsfile set filetype=groovy

" Markdown
" --------
au FileType markdown setlocal ts=2 sw=2 sts=2
au FileType markdown setlocal spell spelllang=en_gb
au FileType markdown inoremap <TAB> <C-t>
" Markdown Syntax Highlighting
let g:vim_markdown_fenced_languages = ['csharp=cs', 'json=javascript']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_conceal = 0
" Set .draft files to Markdown
au BufRead,BufNewFile *.draft set filetype=markdown

" Typescript Settings
au FileType typescript setlocal ts=2 sw=2 sts=2

" Vagrant Files
augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END

" ----------------

" --------------------------------"
" General  Mappings
" --------------------------------"

" When the enter key is pressed it takes away the highlighting in from the
" last text search
nnoremap <silent><CR> :nohlsearch<CR><CR>

" Remap Visual and Insert mode to use Normal Modes Tab Rules
" --------
inoremap >> <c-t>
inoremap << <c-d>

" Map Movement Keys to Ctrl hjlk in Terminal, and Command Modes
" --------
tnoremap <c-h> <Left>
tnoremap <c-h> <Left>
tnoremap <c-j> <Down>
tnoremap <c-k> <Up>
cnoremap <c-l> <Right>
cnoremap <c-j> <Down>
cnoremap <c-k> <Up>
cnoremap <c-l> <Right>

" Tab Control
" --------
" Navigation
map <C-t>k :tabr<cr>
map <C-t>j :tabl<cr>
map <C-t>l :tabn<cr>
map <C-t>h :tabp<cr>
" Close Current Tab
map <C-t>c :tabc<cr>
" Close all other Tabs
map <C-t>o :tabo<cr>
" New Tab - note n is already used as a search text tool and cannot be mapped
map <C-t><c-n> :tabnew<cr>

" Tmux Pane Resizing
" --------
" Terminal
tnoremap <c-a><c-j>  <c-\><c-n>:res-5<CR>i
tnoremap <c-a><c-k>  <c-\><c-n>:res+5<CR>i
tnoremap <c-a><c-h>  <c-\><c-n>:vertical resize -5<CR>i
tnoremap <c-a><c-l>  <c-\><c-n>:vertical resize +5<CR>i
" Insert
inoremap <c-a><c-j>  :res-5<CR>
inoremap <c-a><c-k>  :res+5<CR>
inoremap <c-a><c-h>  <c-\><c-n>:vertical resize -5<CR>i
inoremap <c-a><c-l>  <c-\><c-n>:vertical resize +5<CR>i
" Command
cnoremap <c-a><c-j>  :res-5<CR>
cnoremap <c-a><c-k>  :res+5<CR>
cnoremap <c-a><c-h>  <c-\><c-n>:vertical resize -5<CR>i
cnoremap <c-a><c-l>  <c-\><c-n>:vertical resize +5<CR>i
" Normal
nnoremap <c-a><c-j>  :res-5<CR>
nnoremap <c-a><c-k>  :res+5<CR>
nnoremap <c-a><c-h>  <c-\><c-n>:vertical resize -5<CR>i
nnoremap <c-a><c-l>  <c-\><c-n>:vertical resize +5<CR>i

" Buffer Switch & Delete
" --------
" Buffer Switch
nnoremap <c-b>s :ls<CR>:b<Space>
" Buffer Delete, note: can only delete one buffer at a time
nnoremap <c-b>d :ls<CR>:bd<Space>
" Terminal Commands, autoswitch focussed pane and then change buffer 
" assumes the terminal is horizontally split and on the bottom
tnoremap <c-b>s <c-w>k :ls<CR>:b<Space>
" Buffer Delete, note: can only delete one buffer at a time
tnoremap <c-b>d <c-w>k :ls<CR>:bd<Space>
" ----------------

" --------------------------------"
" Custom Commands
" --------------------------------"

" Jira Csv 
" --------
function! MakeJira()
    set filetype=csv
    normal iProject,Summary,Issue Type,Issue Key,Description,Acceptance Criteria,Lables,Story Link
endfunction

command Jiracsv :call MakeJira()

" ----------------------------------------"
" Leader Remappings, Plugin Commands
" ----------------------------------------"
" Note: I often will use <leader> remappings as a way to distinguish between
" plugins in order to segregate commands.
" This follows the conventions <leader>{plugin key}{command key}
" I've listed already use leader commands here
" Telescope Nvim: <leader>f
" Database - DadBod: : <leader>d
" Snippets - UltiSnips : <leader>s
" Terminal : <leader>t & <leader> q
" Testing - Ultest : <leader>x (T is being used for the terminal)
" Code Alignment - EasyAlign : <leader>e
" REPL - Iron.nvim: <leader>r
" AutoComplete and Diagnostics - coc.nvim: <leader>c

" --------------------------------"
" UltiSnips Options
" --------------------------------"

" UltiSnipsEdit Command
" --------
nnoremap <leader>se :UltiSnipsEdit<CR>

"--------------------------- "
" NerdTree Options 
"--------------------------- "

let g:NERDTreeWinPos="right"
let g:NERDTreeWinSize=45
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1

" NerdTree Git Plugin Symbols
let g:NERDTreeGitStatusUseNerdFonts = 1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber
" Remap the open and close to C-n
map <C-n> :NERDTreeToggle<CR>
" Remap Root Settings for simpler Root Control
let NERDTreeMapChangeRoot='l'
let NERDTreeMapUpdir='h'
" Terminal Commands, autoswitch focussed pane and then switch to nerdtree,
" assumes the terminal is horizontally split and on the bottom
if has('nvim')
    tnoremap <C-n> <C-\><C-n><c-w>k :NERDTreeToggle<CR>
else
    tnoremap <C-n> <c-w>k :NERDTreeToggle<CR>
endif
" ----------------

"--------------------------- "
" Lightline Configuration
"--------------------------- "

" DevIcon FileType
function! DeviconsFileType()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

" DevIcon FileFormat
function! DeviconsFileFormat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" Turn Filename Into FilePath
function! LightlineTruncatedFileName()
    let l:filePath = expand('%')
    return winwidth(0) > 100 ? l:filePath : pathshorten(l:filePath)
endfunction

" Shorten Branch Name If Necessary
function! LightlineGitBranchName()
    let l:gitbranch = gitbranch#name()
    return winwidth(0) > 100 ? l:gitbranch : join(split(l:gitbranch, "-")[-3:], "-")
endfunction

function! LightlineVirtualEnv()
    if ($VIRTUAL_ENV != "")
        let l:virtualenv = split($VIRTUAL_ENV,"/")[-1:][0]
    else
        let l:virtualenv = ""
    endif
    return l:virtualenv
endfunction


" Configuration
let g:lightline = { 'mode_map' : { 'n':'N', 'i':'I','R':'R', 'vb':'V', 'V':'VL', "\<C-v>":'VB', 't':'T', 'c':'X' }, 'colorscheme': 'Tomorrow_Night', 'active': { 'left': [ [ 'mode', 'paste' ], [ 'virtualenv', 'gitbranch', 'filename' ]], 'right': [ [ 'lineinfo' ], [ 'filetype', 'fileencoding' ] ]  }, 'component_function': { 'filename': 'LightlineTruncatedFileName', 'gitbranch': 'LightlineGitBranchName', 'filetype': 'DeviconsFileType', 'fileformat': 'DeviconsFileFormat', 'virtualenv': 'LightlineVirtualEnv' }, }

" --------------------------------"
" Telescope Settings (Neovim Only)
" --------------------------------"

if has('nvim')
    " Find files using Telescope command-line sugar.
    nnoremap <leader>ff <cmd>Telescope find_files<cr>
    nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>
endif

" --------------------------------"
" Easy Align
" --------------------------------"
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap <leader>e <Plug>(EasyAlign)<CR>

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap <leader>e <Plug>(EasyAlign)<CR>

" ----------------

" --------------------------------"
" Database Commands - DadBod
" --------------------------------"

" Options
" --------
let g:db_ui_save_location = '~/.config/db_ui'
let g:dd_ui_use_nerd_fonts = 1

" Mappings
" --------
nnoremap <silent> <leader>du :DBUIToggle<CR>
nnoremap <silent> <leader>df :DBUIFindBuffer<CR>
nnoremap <silent> <leader>dr :DBUIRenameBuffer<CR>
nnoremap <silent> <leader>dl :DBUILastQueryInfo<CR>

" --------------------------------"
" REPL - Iron.nvim
" --------------------------------"

if has('nvim')
    lua << EOF
       iron = require("iron.core")
       iron.setup {
           -- Options
           -- --------
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
           -- --------
           keymaps = {
               send_motion = "<leader>rc", -- repl command
               visual_send = "<leader>rc", -- repl command (visual mode)
               send_file = "<leader>rf", -- repl file
               send_line = "<leader>rl", -- repl line
               send_mark = "<leader>rms", -- repl mark send
               mark_motion = "<leader>rmm", -- repl mark motion
               mark_visual = "<leader>rmm", -- repl mark motion (visual mode)
               remove_mark = "<leader>rmr", -- repl mark remove
               cr = "<leader>r<CR>", -- send a <CR> to the repl
               interrupt = "<leader>rs", -- repl stop
               exit = "<leader>rq", -- repl quit
               clear = "<leader>rc", -- repl clear
           },
       }
EOF

    " Mappings
    " --------
    nnoremap <silent> <leader>ro :IronRepl<CR>

endif





" --------------------------------"
" Editor Config Commands
" --------------------------------"

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
au FileType gitcommit let b:EditorConfig_disable = 1

" --------------------------------"
" Coc-Options Load
" --------------------------------"
au BufRead,BufNewFile .cocrc set filetype=vim
let g:cochome = $HOME . '/.vim/.cocrc'
if filereadable(cochome)
    exec 'source' . cochome
    cabbrev editcoc execute 'e' g:cochome
    cabbrev updatecoc execute 'source' g:cochome
endif

" Allow WorkSpace Specific RCs
if filereadable("./vimwsrc")
    source ./vimwsrc
endif

" Use Deoplete for Intellij Sync
" --------
let g:deoplete#enable_at_startup=1

" ----------------------END OF VIMRC--------------------- "
