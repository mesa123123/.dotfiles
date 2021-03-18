" Set No Compatible allows Coc to work for some weird reason?
set nocompatible

" set the mapleader
let mapleader = "\\"

" Load Plugings
" --------
call plug#begin('/home/$USER/.vim/pack/my_plugins/start')

Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'yggdroot/indentline'
Plug 'plasticboy/vim-markdown'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'alfredodeza/pytest.vim'
Plug 'mfukar/robotframework-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'ryanoasis/vim-devicons'
Plug 'nvie/vim-flake8'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'tpope/vim-fugitive'
Plug 'luochen1990/rainbow'
Plug 'scrooloose/syntastic'
Plug 'derekwyatt/vim-scala'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sirver/ultisnips'

call plug#end()

" ----------------

" --------------------------------"
" General Options Setting
" --------------------------------"

set number
let python_highlight_all=1
syntax on
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

" ----------------


" --------------------------------"
" Terminal Settings
" --------------------------------"
"  VSCode Terminal Behaviour
"  ----
" Terminal Alias and Keyboard Settings
cabbrev bterm bo term
" Open Terminal if Terminal has previously been opened then open the
" previously opened Terminal
function TerminalBufferNumbers()
    return filter(map(getbufinfo(), 'v:val.bufnr'), 'getbufvar(v:val,"&buftype") is# "terminal"')
endfunction
nnoremap <silent><expr><leader>t empty(TerminalBufferNumbers())  ? 
            \ ':execute "bo term"<CR><c-\><c-n>:res-10<CR>icls<CR>' : 
            \ ':let ntbn = TerminalBufferNumbers()[0]<CR>:exe "sbuffer".ntbn<CR>:res-10<CR>i' 
" Hide Terminal
tnoremap <silent><leader>t <c-\><c-n>:q<CR>
" Exit Terminal Completely
tnoremap <silent><leader>q exit<CR>
" ----------------

" ------------------------------"
" Language Specific Settings
" ------------------------------"

"   Language C++
au FileType cpp setlocal et ts=2 sw=2

" Language Python
let g:pymode_rope = 1
let g:pymode_rope_goto_definition_bind = '<c-c>g'
let g:pymode_rope_goto_definition_cmd = 'new'
let g:pymode_lint = 0
let g:pymode_lint_on_write = 0
let g:pymode_lint_on_fly = 0
au FileType python setlocal et ts=4 sw=4 sts=4


"Language Markdown
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
" ----------------

" --------------------------------"
" General  Mappings
" --------------------------------"

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

" Tabs Remapping
map <C-t><k> :tabr<cr>
map <C-t><j> :tabl<cr>
map <C-t><l> :tabp<cr>
map <C-t><h> :tabn<cr>

" Tmux Pane Resizing
" --------
" Terminal
tnoremap <c-a><c-j>  <c-\><c-n>:res-5<CR>i
tnoremap <c-a><c-k>  <c-\><c-n>:res+5<CR>i
" Insert
inoremap <c-a><c-j>  :res-5<CR>
inoremap <c-a><c-k>  :res+5<CR>
" Command
cnoremap <c-a><c-j>  :res-5<CR>
cnoremap <c-a><c-k>  :res+5<CR>
" Normal
nnoremap <c-a><c-j>  :res-5<CR>
nnoremap <c-a><c-k>  :res+5<CR>

" ----------------

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

" ----------------

"--------------------------- "
" Lightline Configuration
"--------------------------- "

" coc options for lightline
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

" Lightline Options
let g:lightline = { 'colorscheme': 'onehalfdark', 'active': { 'left': [ [ 'mode', 'paste' ], [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ] }, 'component_function': { 'gitbranch': 'FugitiveHead', 'cocstatus': 'coc#status', 'currentfunction': 'CocCurrentFunction' }, }

" Lightline Coc Config
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" ----------------

" Devicons Enablement
let g:webdevicons_enable_airline_statusline=1
let g:webdevicons_enable_airline_tabline=1


"Rainbow Brackets Options
let g:rainbow_active=1

if exists("g:loaded_webdevicons")
	  call webdevicons#refresh()
  endif

" status line updates
set laststatus=2

" --------------------------------------------"
" COC Options
" --------------------------------------------"
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
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
" ----------------


" ------------------------------------------"
" BClose Command "
" ------------------------------------------"
" Delete Buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
    finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
    let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
    if empty(a:buffer)
        let btarget = bufnr('%')
    elseif a:buffer =~ '^\d\+$'
        let btarget = bufnr(str2nr(a:buffer))
    else
        let btarget = bufnr(a:buffer)
    endif
    if btarget < 0
        call s:Warn('No matching buffer for '.a:buffer)
        return
    endif
    if empty(a:bang) && getbufvar(btarget, '&modified')
        call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
        return
    endif
    " Numbers of windows that view target buffer which we will delete.
    let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
    if !g:bclose_multiple && len(wnums) > 1
        call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
        return
    endif
    let wcurrent = winnr()
    for w in wnums
        execute w.'wincmd w'
        let prevbuf = bufnr('#')
        if prevbuf > 0 && buflisted(prevbuf) && prevbuf != btarget 
            buffer #
        else 
            bprevious
        endif
        if btarget == bufnr('%')
            " Numbers of listed buffers which are not the target to be deleted.
            let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
            " Listed, not target, and not displayed.
            let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
            " Take the first buffer, if any (could be more intelligent).
            let bjump = (bhidden + blisted + [-1])[0]
            if bjump > 0
                execute 'buffer '.bjump
            else 
                execute 'enew'.a:bang
            endif
        endif
    endfor
    execute 'bdelete'.a:bang.' '.btarget
    execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose(<q-bang>, <q-args>)
nnoremap <silent> <Leader>bd :Bclose<CR>


" ----------------------END OF VIMRC--------------------- "

