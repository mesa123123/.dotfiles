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

Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'yggdroot/indentline'
Plug 'plasticboy/vim-markdown'
Plug 'alfredodeza/pytest.vim'
Plug 'mfukar/robotframework-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'ryanoasis/vim-webdevicons'
Plug 'nvie/vim-flake8'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'luochen1990/rainbow'
Plug 'derekwyatt/vim-scala'
Plug 'sirver/ultisnips'
Plug 'itchyny/vim-gitbranch'
Plug 'mechatroner/rainbow_csv'
Plug 'ekalinin/Dockerfile.vim'
Plug 'rust-lang/rust.vim'
Plug 'sheerun/vim-polyglot'
Plug 'arzg/vim-rust-syntax-ext'
Plug 'junegunn/goyo.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fladson/vim-kitty', {'branch': 'main'}
Plug 'takac/vim-hardtime'
Plug 'purescript-contrib/purescript-vim'
Plug 'hashivim/vim-terraform'
Plug 'hashivim/vim-vagrant'
Plug 'tpope/vim-fugitive'
Plug 'vimwiki/vimwiki'

call plug#end()

" Plugin Settings
" --------
let g:plug_timeout = 120
let g:plug_retries = 5
let g:plug_threads = 32

" ----------------

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
" Line Numbers On
set number
" Language Syntax On
syntax on
let python_highlight_all=1
set linebreak
set autoindent
set nofoldenable
set encoding=UTF-8
set noshowmode
set splitbelow
" Set up FileType functionality
filetype on
filetype plugin indent on

"	Color Scheme Options
set termguicolors
set t_Co=25
colorscheme onehalfdark

"	Tabstop & Shiftwidth
set tabstop=4
set shiftwidth=4
set expandtab

"Rainbow Brackets Options
let g:rainbow_active=1

if exists("g:loaded_webdevicons")
      call webdevicons#refresh()
  endif

" Status Line Updates
set laststatus=2

" Hardtime On
let g:hardtime_default_on = 1
let g:hardtime_showing = 1
let g:hardime_allow_different_key = 1

" Web Dev Icons Settings
" --------
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

" Hardtime on
" --------
let g:hardtime_default_on = 1

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

" HCL Language
au BufRead,BufNewFile *.hcl set filetype=ini

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

" Lightline functions
" --------
" coc options for lightline
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

" DevIcon FileType
function! DeviconsFileType()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

" DevIcon FileFormat
function! DeviconsFileFormat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" Lightline Configuration
let g:lightline = { 'colorscheme': 'Tomorrow_Night', 'active': { 'left': [ [ 'mode', 'paste' ], [ 'gitbranch' ], [ 'cocstatus', 'currentfunction', 'filename' ] ], 'right': [ [ 'lineinfo' ], [ 'fileencoding', 'fileformat', 'filetype' ] ]  }, 'component_function': { 'gitbranch': 'gitbranch#name','cocstatus': 'coc#status', 'currentfunction': 'CocCurrentFunction', 'filetype': 'DeviconsFileType', 'fileformat': 'DeviconsFileFormat' }, }

" Lightline Coc Config
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
" ----------------

" --------------------------------------------"
" Coc Options
" --------------------------------------------"
" Coc-Command Abbreviation
" --------
cabbrev ccc CocCommand
" Global Extensions
" --------
let g:coc_global_extensions = ['coc-css', 'coc-docker', 'coc-html', 'coc-json', 'coc-markdownlint', 'coc-pyright', 'coc-solargraph', 'coc-toml', 'coc-tsserver', 'coc-ultisnips', 'coc-word', 'coc-yaml', 'coc-git', 'coc-rls']
" Recommended Options
" --------
" TextEdit might fail if hidden is not set.
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=200
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
if has("patch-8.1.1564")   
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif
" Use tab for trigger completion with characters ahead and navigate. NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin before putting this into your config.
inoremap <silent><expr> <c-l>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><c-h> pumvisible() ? "\<C-p>" : "\<C-h>"
" Make <CR> auto-select the first completion item and notify coc.nvim to format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() 
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Formatting selected code.
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

augroup mygroup
autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json,markdown setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap g= <Plug>(coc-codeaction-selected)<CR>
nmap g= <Plug>(coc-codeaction-selected)<CR>
" ----------------

" Allow WorkSpace Specific RCs
set exrc
set secure



" ----------------------END OF VIMRC--------------------- "

