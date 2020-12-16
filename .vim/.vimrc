" Set No Compatible allows Coc to work for some weird reason?
set nocompatible

" Plugins Load
call plug#begin('/home/$USER/.vim/pack/my_plugins/start')

Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'yggdroot/indentline'
Plug 'hallison/vim-markdown'
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
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

" NerdTree Options 
let g:NERDTreeWinPos="right"
let g:NERDTreeWinSize=60
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber


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

" Devicons Enablement
let g:webdevicons_enable_airline_statusline=1
let g:webdevicons_enable_airline_tabline=1

" Instant Markdown Preview Options
let g:instant_markdown_python=1

"Rainbow Brackets Options
let g:rainbow_active=1

if exists("g:loaded_webdevicons")
	  call webdevicons#refresh()
  endif

" status line updates
set laststatus=2


" COC Options
" --------------------------------------------"
" If hidden is not set, TextEdit might fail.
set hidden
" Some servers have issues with backup files
set nobackup
set nowritebackup
" You will have a bad experience with diagnostic messages with the default
" 4000
set updatetime=300
" Don't give |ins-completion-menu| messages.
set shortmess+=c
" Always show signcolumns
set signcolumn=yes
" Help Vim recognize *.sbt and *.sc as Scala files
au BufRead,BufNewFile *.sbt,*.sc set filetype=scala

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other
" plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
	  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Used in the tab autocompletion for coc
function! s:check_back_space() abort
	let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Used to expand decorations in worksheets
nmap <Leader>ws <Plug>(coc-metals-expand-decoration

" Use K to either doHover or show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>fs  <Plug>(coc-format-selected)
nmap <leader>fs  <Plug>(coc-format-selected)

augroup mygroup
	autocmd!
	" Setup formatexpr specified filetype(s).
	autocmd FileType scala setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of current line
xmap <leader>a  <Plug>(coc-codeaction-line)
nmap <leader>a  <Plug>(coc-codeaction-line)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)`

" Trigger for code actions (requires codeLens.enable in coc_config)
nnoremap <leader>cl :<C-u>call CocActionAsync('codeLensAction')<CR>

" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Notify coc.nvim that <enter> has been pressed. Currently used for the formatOnType feature.
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Toggle panel with Tree Views
nnoremap <silent> <space>t :<C-u>CocCommand metals.tvp<CR>
" Toggle Tree View 'metalsPackages'
nnoremap <silent> <space>tp :<C-u>CocCommand metals.tvp metalsPackages<CR>
" Toggle Tree View 'metalsCompile'
nnoremap <silent> <space>tc :<C-u>CocCommand metals.tvp metalsCompile<CR>
" Toggle Tree View 'metalsBuild'
nnoremap <silent> <space>tb :<C-u>CocCommand metals.tvp metalsBuild<CR>
" Reveal current current class (trait or object) in Tree View 'metalsPackages'
nnoremap <silent> <space>tf :<C-u>CocCommand metals.revealInTreeView metalsPackages<CR

" ------------------------------------------- "

" Tabs Remapping
map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-t><left> :tabp<cr>
map <C-t><right> :tabn<cr>

" NERDTREE remap
" For some reason I have to put this last?
map <C-n> :NERDTreeToggle<CR>

" ----------------------END OF VIMRC--------------------- "

