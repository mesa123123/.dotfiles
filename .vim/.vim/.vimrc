"		Plugins
call plug#begin('/home/bowmanpete/.vim/pack/my_plugins/start')

Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'yggdroot/indentline'
Plug 'hallison/vim-markdown'
Plug 'klen/python-mode'
Plug 'alfredodeza/pytest.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'ryanoasis/vim-devicons'
Plug 'nvie/vim-flake8'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'tpope/vim-fugitive'
Plug 'luochen1990/rainbow'
Plug 'scrooloose/syntastic'
Plug 'tfnico/vim-gradle'
Plug 'derekwyatt/vim-scala'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sirver/ultisnips'

call plug#end()

"	Options Setting
set number
let python_highlight_all=1
syntax on
set tabstop=4
set shiftwidth=4
set autoindent
set nofoldenable
set encoding=UTF-8
set noshowmode
filetype on
filetype plugin indent on
"	Color Scheme Options
set termguicolors
set t_Co=256
set laststatus=2
colorscheme onehalfdark

"		Auto-close brackets
" inoremap " ""<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
" inoremap {<CR> {<CR>}<ESC>O
" inoremap {;<CR> {<CR>};<ESC>O

" Filetype Options
" Json Comments Enable
autocmd FileType json syntax match Comment +\/\/.\+$+

" NerdTree Options 
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinPos="right"
let g:NERDTreeWinSize=60

"	Pymode Options
let g:pymode_python = 'python3'
autocmd Filetype python setlocal et ts=4 sw=4 sts=4


" Coc Options for LightLine
function! CocCurrentFunction()
	    return get(b:, 'coc_current_function', '')
	endfunction


"		Lightline Options"
let g:lightline = { 'colorscheme': 'onehalfdark',
					\ 'active': {
     					 \   'left': [ [ 'mode', 'paste' ],
						\  [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
     					 \ },
					\ 'component_function': {
                        \   'gitbranch': 'FugitiveHead',
						\   'cocstatus': 'coc#status',
                        \   'currentfunction': 'CocCurrentFunction'
                        \ },
									\}
"	DevIcons Enablement
let g:webdevicons_enable_airline_statusline=1
let g:webdevicons_enable_airline_tabline=1


"  Pymode Options
let g:pymode_lint=0

"	Instant Markdown Preview Options
  "Uncomment to override defaults:
  "let g:instant_markdown_slow = 1
  "let g:instant_markdown_autostart = 0
  "let g:instant_markdown_open_to_the_world = 1
  "let g:instant_markdown_allow_unsafe_content = 1
  "let g:instant_markdown_allow_external_content = 0
  "let g:instant_markdown_mathjax = 1
  "let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
  "let g:instant_markdown_autoscroll = 0
let g:instant_markdown_port = 8888
let g:instant_markdown_python = 1

" Rainbow Brackets Options
let g:rainbow_active=1

" Syntastic Options
let g:syntastic_check_on_open = 1
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list=1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_wq = 0
map <C-n> :NERDTreeToggle<CR>


if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif


" Code Complete Configuration
" -----------------------------------

set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
" Always show signcolumns
set signcolumn=yes
" Help Vim recognize *.sbt and *.sc as Scala files
au BufRead,BufNewFile *.sbt,*.sc set filetype=scala
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other
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
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"  
" Navigation Diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Used to expand decorations in worksheets
nmap <Leader>ws <Plug>(coc-metals-expand-decoration)
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
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
augroup mygroup
     autocmd!
    " Setup formatexpr specified filetype(s)
     autocmd FileType scala setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
     autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Remap for do codeAction of current line
xmap <leader>a <Plug>(coc-codeaction-line)
nmap <leader>a <Plug>(coc-codeaction-line)
" Fix autofix problem of current line
nmap <leader>qf <Plug>(coc-fix-current)
" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Trigger for code actions
nnoremap <leader>cl :<C-u>call CocActionAsync('codeLensAction')<CR>
" Show all diagnostics
nnoremap <silent> <space>a : <C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p :<C-u>CocListResume<CR>
" Notify coc.nvim that <enter> has been pressed. Currently used for the formatOnType feature.
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
			\:"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Toggle panel with Tree Views
nnoremap <silent> <space>t :<C-u>CocCommand metals.tvp<CR>       
" Toggle Tree View 'metalsPackages'
nnoremap <silent> <space>tp :<C-u>CocCommand metals.tvp metalsPackages<CR>
" Toggle Tree View 'metalsCompile'
nnoremap <silent> <space>tc :<C-u>CocCommand metals.tvp metalsCompile<CR>
" Toggle Tree View 'metalsBuild'
nnoremap <silent> <space>tb :<C-u>CocCommand metals.tvp metalsBuild<CR>
" Reveal current current class (trait or object) in Tree View 'metalsPackages'
nnoremap <silent> <space>tf :<C-u>CocCommand metals.revealInTreeView metalsPackages<CR>

" ---------------------------------------------------------------------------------

" Ultisnips Recommended Shortcuts
" Ties the tab key to trigger the snippet
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab-j>"
let g:UltiSnipsJumpBackwardTrigger="<tab-k>"
" Creates a Split Window when you want to work with user snippets
let g:UltiSnipsEditSplit="vertical"

" Tabs Remapping
map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-t><left> :tabp<cr>
map <C-t><right> :tabn<cr>



