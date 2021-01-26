" Set No Compatible allows Coc to work for some weird reason?
set nocompatible

" Plugins Load
call plug#begin('/home/$USER/.vim/pack/my_plugins/start')

Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'yggdroot/indentline'
Plug 'plasticboy/vim-markdown'
Plug 'klen/python-mode'
Plug 'alfredodeza/pytest.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'ryanoasis/vim-devicons'
Plug 'nvie/vim-flake8'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'tpope/vim-fugitive'
Plug 'luochen1990/rainbow'
Plug 'scrooloose/syntastic'
Plug 'derekwyatt/vim-scala'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
Plug 'sirver/ultisnips'


call plug#end()

"	Options Setting
set number
let python_highlight_all=1
syntax on
set linebreak
set autoindent
set nofoldenable
set encoding=UTF-8
set noshowmode
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

" Language Specific Settings
" ------------------------------"

"   Language C++
au FileType cpp setlocal et ts=2 sw=2

" Language Python
let g:pymode_python = 'python3'
let g:pymode_rope = 0
au FileType python setlocal et ts=4 sw=4 sts=4

"Language Markdown
au FileType markdown setlocal ts=2 sw=2 sts=2

" Set .draft files to Markdown
au BufRead,BufNewFile *.draft set filetype=markdown
" ----------------

" NerdTree Options 
let g:NERDTreeWinPos="right"
let g:NERDTreeWinSize=60
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber
" Remap the open and close to C-n
map <C-n> :NERDTreeToggle<CR>

" Lightline Configuration
"--------------------------- "
" coc options for lightline
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

"       Lightline Options"
let g:lightline = { 'colorscheme': 'onehalfdark', 'active': { 'left': [ [ 'mode', 'paste' ], [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ] }, 'component_function': { 'gitbranch': 'FugitiveHead', 'cocstatus': 'coc#status', 'currentfunction': 'CocCurrentFunction' }, }

" Lightline Coc Config
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" ----------------

" Devicons Enablement
let g:webdevicons_enable_airline_statusline=1
let g:webdevicons_enable_airline_tabline=1

" Markdown Syntax Highlighting
let g:vim_markdown_fenced_languages = ['csharp=cs', 'json=javascript']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_conceal = 0

"Rainbow Brackets Options
let g:rainbow_active=1

if exists("g:loaded_webdevicons")
	  call webdevicons#refresh()
  endif

" status line updates
set laststatus=2


" COC Options
" --------------------------------------------"
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
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

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
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)


" ------------------------------------------- "

" Tabs Remapping
map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-t><left> :tabp<cr>
map <C-t><right> :tabn<cr>

" ----------------------END OF VIMRC--------------------- "

