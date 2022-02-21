---------------------------------
-- Priority Settings
--------------------------------
-- Set the config path
vim.g["config_path"] = "~/config/nvim"
-- Set the mapleader
vim.g["mapleader"] = "\\"

-- Vim options and api to variables
----------------
local cmd = vim.cmd -- vim commands
local api = vim.api -- vim api (I'm not sure what this does)
local fn = vim.fn -- vim functions
local g = vim.g -- global variables
local opt = vim.opt -- vim options
local gopt = vim.o -- global options
local bopt = vim.bo -- buffer options
local wopt = vim.wo -- window options

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
    -- Colors and Themes and UI
    use {'ii14/onedark.nvim'}
    -- New Dev Icons Please
    use {'kyazdani42/nvim-web-devicons'}
    -- NEED A NEW LIGHTLINE
    -- NerdTree and related plugins
    use {"preservim/nerdtree"}
    -- Hardtime
    use {"takac/vim-hardtime"}
    -- IndentLine
    use {"yggdroot/indentline"}
    -- Snippets Extensions - RIP ULtiSnips
    use {"L3MON4D3/LuaSnip"}
    -- Language Server Protocol this uses syntax etc to help coding
    use {"neovim/nvim-lspconfig"}
    -- Help with the installaiton of lsps
    use {"williamboman/nvim-lsp-installer"}
    -- Autocompletion
    use {"hrsh7th/nvim-cmp"} -- Autocompletion plugin
    use {"hrsh7th/cmp-nvim-lsp"} -- LSP source for nvim-cmp
    use {"hrsh7th/cmp-buffer"} -- Autocompletion from the buffer
    use {"hrsh7th/cmp-path"} -- Auocompletion for path strings
    use {"saadparwaiz1/cmp_luasnip"} -- Autocompletion from the lanuguages snippets
    -- Zen Mode
    use {"junegunn/goyo.vim"}
    -- Markdown Helpers
    use {"plasticboy/vim-markdown"}
    -- Git Helper
    use {"tpope/vim-fugitive"}
    -- AutoUpdate Plugins on open
    require('packer').sync() 
end)

--------------------------------
-- Configure Vimrc from Vim
--------------------------------
cmd [[cabbrev editvim e ~/.config/nvim/init.lua]]
cmd [[cabbrev updatevim source ~/.config/nvim/init.lua]]

--------------------------------
-- General Options Setting
--------------------------------
-- Line Numbers On
opt.number = true
-- Filetype Enable
cmd [[
filetype on
filetype plugin indent on
]]
-- Other Enconding and Formatting settings
opt.linebreak = true
opt.autoindent = true
cmd 'set nofoldenable'
opt.encoding = 'UTF-8'
cmd 'set noshowmode'
opt.splitbelow = true

--------------------------------
-- Color Scheme Options
--------------------------------
opt.termguicolors = true
cmd 'set t_Co=25'
cmd 'colorscheme onedark'
-- Tabstop & Shiftwidth
opt.tabstop= 4
opt.shiftwidth= 4
opt.expandtab = true
-- Rainbow Brackets Options
-- let g:rainbow_active=1
-- 
-- Load Webdevicons
require'nvim-web-devicons'.setup { default = true }
-- 
-- Status Line Updates
opt.laststatus = 2
-- 
-- " Hardtime On
-- let g:hardtime_default_on = 1
-- let g:hardtime_showing = 1
-- let g:hardime_allow_different_key = 1
-- let g:hardtime_showmsg = 1
-- 
-- " Web Dev Icons Settings
-- " --------
-- let g:webdevicons_enable = 1
-- let g:webdevicons_enable_nerdtree = 1
-- let g:webdevicons_conceal_nerdtree_brackets = 1
-- let g:WebDevIconsUnicodeDecorateFolderNodes = 1
-- 
-- " Vimwiki Global Syntax Off
-- " --------
-- let g:vimwiki_global_ext = 0
-- 
-- " ----------------
-- 
-- " --------------------------------"
-- " Terminal Settings
-- " --------------------------------"
-- "  VSCode Terminal Behaviour
-- "  ----
-- " Terminal Alias and Keyboard Settings
-- if has('nvim')
--     cabbrev bterm below new<CR>:terminal 
-- else
--     cabbrev bterm bo term
-- endif
-- " Open Terminal if Terminal has previously been opened then open the
-- " previously opened Terminal
-- function TerminalBufferNumbers()
--     return filter(map(getbufinfo(), 'v:val.bufnr'), 'getbufvar(v:val,"&buftype") is# "terminal"')
-- endfunction
-- nmap <silent><expr><leader>t empty(TerminalBufferNumbers())  ? 
--             \ ':bterm<CR><c-\><c-n>:res-10<CR>icls && cd ' . g:cwd . '<CR>' : 
--             \ ':let ntbn = TerminalBufferNumbers()[0]<CR>:exe "sbuffer".ntbn<CR>:res-10<CR>i' 
-- " Hide Terminal
-- tnoremap <silent><leader>t <c-\><c-n>:q<CR>
-- " Exit Terminal Completely
-- if has('nvim')
--     tnoremap <silent><leader>q exit<CR><CR>
-- else
--     tnoremap <silent><leader>q exit<CR>
-- endif
-- 
-- " Get rid of terminal line numbers
-- " --------
-- if has('nvim')
--     autocmd TermOpen * setlocal nonumber norelativenumber
-- endif
-- " ----------------
-- 
-- " ------------------------------"
-- " Language Specific Settings
-- " ------------------------------"
-- function RunMermaidPreview()
--     execute '!/home/$USER/dev/projects/vimmermaid/stap.sh &'
-- endfunction
-- au BufNewFile,BufRead *.mermaid set filetype=mermaid
-- au Filetype mermaid call RunMermaidPreview()
-- 
-- " C++ Language 
-- au FileType cpp setlocal et ts=2 sw=2
-- 
-- " HCL Language
-- au BufRead,BufNewFile *.hcl set filetype=ini
-- 
-- " JenkinsFile
-- au BufNewFile,BufRead Jenkinsfile set filetype=groovy
-- 
-- " Markdown
-- " --------
-- au FileType markdown setlocal ts=2 sw=2 sts=2
-- au FileType markdown setlocal spell spelllang=en_gb
-- au FileType markdown inoremap <TAB> <C-t>
-- " Markdown Syntax Highlighting
-- let g:vim_markdown_fenced_languages = ['csharp=cs', 'json=javascript']
-- let g:vim_markdown_folding_disabled = 1
-- let g:vim_markdown_conceal_code_blocks = 0
-- let g:vim_markdown_conceal = 0
-- " Set .draft files to Markdown
-- au BufRead,BufNewFile *.draft set filetype=markdown
-- 
-- " Python Language
-- let g:pymode_rope = 0
-- let g:pymode_rope_goto_definition_bind = '<c-c>g'
-- let g:pymode_rope_goto_definition_cmd = 'new'
-- let g:pymode_lint = 0
-- let g:pymode_lint_on_write = 0
-- let g:pymode_lint_on_fly = 0
-- au FileType python setlocal et ts=4 sw=4 sts=4
-- 
-- " Typescript Settings
-- au FileType typescript setlocal ts=2 sw=2 sts=2
-- 
-- " Vagrant Files
-- augroup vagrant
--   au!
--   au BufRead,BufNewFile Vagrantfile set filetype=ruby
-- augroup END
-- 
-- " ----------------
-- 
-- " --------------------------------"
-- " General  Mappings
-- " --------------------------------"
-- 
-- " When the enter key is pressed it takes away the highlighting in from the
-- " last text search
-- nnoremap <silent><CR> :nohlsearch<CR><CR>
-- 
-- " Remap Visual and Insert mode to use Normal Modes Tab Rules
-- " --------
-- inoremap >> <c-t>
-- inoremap << <c-d>
-- 
-- " Map Movement Keys to Ctrl hjlk in Terminal, and Command Modes
-- " --------
-- tnoremap <c-h> <Left>
-- tnoremap <c-h> <Left>
-- tnoremap <c-j> <Down>
-- tnoremap <c-k> <Up>
-- cnoremap <c-l> <Right>
-- cnoremap <c-j> <Down>
-- cnoremap <c-k> <Up>
-- cnoremap <c-l> <Right>
-- 
-- " Tab Control
-- " --------
-- " Navigation
-- map <C-t>k :tabr<cr>
-- map <C-t>j :tabl<cr>
-- map <C-t>l :tabn<cr>
-- map <C-t>h :tabp<cr>
-- " Close Current Tab
-- map <C-t>c :tabc<cr>
-- " Close all other Tabs
-- map <C-t>o :tabo<cr>
-- " New Tab - note n is already used as a search text tool and cannot be mapped
-- map <C-t><c-n> :tabnew<cr>
-- 
-- " Tmux Pane Resizing
-- " --------
-- " Terminal
-- tnoremap <c-a><c-j>  <c-\><c-n>:res-5<CR>i
-- tnoremap <c-a><c-k>  <c-\><c-n>:res+5<CR>i
-- tnoremap <c-a><c-h>  <c-\><c-n>:vertical resize -5<CR>i
-- tnoremap <c-a><c-l>  <c-\><c-n>:vertical resize +5<CR>i
-- " Insert
-- inoremap <c-a><c-j>  :res-5<CR>
-- inoremap <c-a><c-k>  :res+5<CR>
-- inoremap <c-a><c-h>  <c-\><c-n>:vertical resize -5<CR>i
-- inoremap <c-a><c-l>  <c-\><c-n>:vertical resize +5<CR>i
-- " Command
-- cnoremap <c-a><c-j>  :res-5<CR>
-- cnoremap <c-a><c-k>  :res+5<CR>
-- cnoremap <c-a><c-h>  <c-\><c-n>:vertical resize -5<CR>i
-- cnoremap <c-a><c-l>  <c-\><c-n>:vertical resize +5<CR>i
-- " Normal
-- nnoremap <c-a><c-j>  :res-5<CR>
-- nnoremap <c-a><c-k>  :res+5<CR>
-- nnoremap <c-a><c-h>  <c-\><c-n>:vertical resize -5<CR>i
-- nnoremap <c-a><c-l>  <c-\><c-n>:vertical resize +5<CR>i
-- 
-- " Buffer Switch & Delete
-- " --------
-- " Buffer Switch
-- nnoremap <c-b>s :ls<CR>:b<Space>
-- " Buffer Delete, note: can only delete one buffer at a time
-- nnoremap <c-b>d :ls<CR>:bd<Space>
-- " Terminal Commands, autoswitch focussed pane and then change buffer 
-- " assumes the terminal is horizontally split and on the bottom
-- tnoremap <c-b>s <c-w>k :ls<CR>:b<Space>
-- " Buffer Delete, note: can only delete one buffer at a time
-- tnoremap <c-b>d <c-w>k :ls<CR>:bd<Space>
-- " ----------------
-- 
-- " UltiSnipsEdit Command
-- " --------
-- nnoremap <leader>se :UltiSnipsEdit<CR>
-- 
-- "--------------------------- "
-- " NerdTree Options 
-- "--------------------------- "
-- 
-- let g:NERDTreeWinPos="right"
-- let g:NERDTreeWinSize=45
-- let NERDTreeShowLineNumbers=1
-- let NERDTreeShowHidden=1
-- 
-- " NerdTree Git Plugin Symbols
-- let g:NERDTreeGitStatusUseNerdFonts = 1
-- " make sure relative line numbers are used
-- autocmd FileType nerdtree setlocal relativenumber
-- " Remap the open and close to C-n
-- Let Ctrl-n toggle NERDTree
api.nvim_set_keymap('', '<C-n>', ':NERDTreeToggle<CR>', {})
-- " Remap Root Settings for simpler Root Control
-- let NERDTreeMapChangeRoot='l'
-- let NERDTreeMapUpdir='h'
-- " Terminal Commands, autoswitch focussed pane and then switch to nerdtree,
-- " assumes the terminal is horizontally split and on the bottom
-- if has('nvim')
--     tnoremap <C-n> <C-\><C-n><c-w>k :NERDTreeToggle<CR>
-- else
--     tnoremap <C-n> <c-w>k :NERDTreeToggle<CR>
-- endif
-- " ----------------
-- 
-- "--------------------------- "
-- " Lightline Configuration
-- "--------------------------- "
-- 
-- " Lightline functions
-- " --------
-- " coc options for lightline
-- function! CocCurrentFunction()
--     return get(b:, 'coc_current_function', '')
-- endfunction
-- 
-- " DevIcon FileType
-- function! DeviconsFileType()
--     return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
-- endfunction
-- 
-- " DevIcon FileFormat
-- function! DeviconsFileFormat()
--     return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
-- endfunction
-- 
-- " Lightline Configuration
-- let g:lightline = { 'colorscheme': 'Tomorrow_Night', 'active': { 'left': [ [ 'mode', 'paste' ], [ 'gitbranch' ], [ 'cocstatus', 'currentfunction', 'filename' ] ], 'right': [ [ 'lineinfo' ], [ 'fileencoding', 'fileformat', 'filetype' ] ]  }, 'component_function': { 'gitbranch': 'gitbranch#name','cocstatus': 'coc#status', 'currentfunction': 'CocCurrentFunction', 'filetype': 'DeviconsFileType', 'fileformat': 'DeviconsFileFormat' }, }
-- 
-- " Lightline Coc Config
-- autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
-- " ----------------
-- 
-- " --------------------------------------------"
-- " Coc Options
-- " --------------------------------------------"
-- " Coc-Command Abbreviation
-- " --------
-- cabbrev ccc CocCommand
-- " Global Extensions
-- " --------
-- let g:coc_global_extensions = ['coc-css', 'coc-docker', 'coc-html', 'coc-json', 'coc-markdownlint', 'coc-pyright', 'coc-solargraph', 'coc-toml', 'coc-tsserver', 'coc-ultisnips', 'coc-word', 'coc-yaml', 'coc-git', 'coc-rls', 'coc-go', 'coc-omnisharp']
-- " Recommended Options
-- " --------
-- " TextEdit might fail if hidden is not set.
-- set hidden
-- " Some servers have issues with backup files, see #649.
-- set nobackup
-- set nowritebackup
-- " Give more space for displaying messages.
-- set cmdheight=2
-- " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
-- set updatetime=200
-- " Don't pass messages to |ins-completion-menu|.
-- set shortmess+=c
-- " Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
-- if has("patch-8.1.1564")   
--     " Recently vim can merge signcolumn and number column into one
--     set signcolumn=number
-- else
--     set signcolumn=yes
-- endif
-- " Use tab for trigger completion with characters ahead and navigate. NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin before putting this into your config.
-- inoremap <silent><expr> <c-l>
--     \ pumvisible() ? "\<C-n>" :
--     \ <SID>check_back_space() ? "\<TAB>" :
--     \ coc#refresh()
-- inoremap <expr><c-h> pumvisible() ? "\<C-p>" : "\<C-h>"
-- " Make <CR> auto-select the first completion item and notify coc.nvim to format on enter, <cr> could be remapped by other vim plugin
-- inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() 
--             \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
-- " Use `[g` and `]g` to navigate diagnostics
-- " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
-- nmap <silent> [g <Plug>(coc-diagnostic-prev)
-- nmap <silent> ]g <Plug>(coc-diagnostic-next)
-- " GoTo code navigation.
-- nmap <silent> gd <Plug>(coc-definition)
-- nmap <silent> gy <Plug>(coc-type-definition)
-- nmap <silent> gi <Plug>(coc-implementation)
-- nmap <silent> gr <Plug>(coc-references)
-- " Use K to show documentation in preview window.
-- nnoremap <silent> K :call <SID>show_documentation()<CR>
-- 
-- function! s:show_documentation()
--     if (index(['vim','help'], &filetype) >= 0)
--         execute 'h '.expand('<cword>')
--     elseif (coc#rpc#ready())
--         call CocActionAsync('doHover')
--     else
--         execute '!' . &keywordprg . " " . expand('<cword>')
--     endif
-- endfunction
-- " Highlight the symbol and its references when holding the cursor.
-- autocmd CursorHold * silent call CocActionAsync('highlight')
-- " Symbol renaming.
-- nmap <leader>rn <Plug>(coc-rename)
-- 
-- " Add `:Format` command to format current buffer.
-- command! -nargs=0 Format :call CocAction('format')
-- 
-- " Formatting selected code.
-- xmap <leader>f <Plug>(coc-format-selected)
-- nmap <leader>f <Plug>(coc-format-selected)
-- 
-- augroup mygroup
-- autocmd!
--     " Setup formatexpr specified filetype(s).
--     autocmd FileType typescript,json,markdown setl formatexpr=CocAction('formatSelected')
--     " Update signature help on jump placeholder.
--     autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
-- augroup end
-- 
-- " Applying codeAction to the selected region.
-- " Example: `<leader>aap` for current paragraph
-- xmap g= <Plug>(coc-codeaction-selected)<CR>
-- nmap g= <Plug>(coc-codeaction-selected)<CR>
-- 
-- " Adding Auto Import Resolution
-- autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
-- 
-- " ----------------
-- 
-- " Allow WorkSpace Specific RCs
-- if filereadable("./vimwsrc")
--     source ./vimwsrc
-- endif
-- 
-- " ----------------------END OF VIMRC--------------------- "
