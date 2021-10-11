"Preamble{{{
syntax on           "syntax highlight
filetype plugin on  
filetype indent on
set nocompatible "vi is dead! Long live vim!
set modelines=0  "Security reasons
"}}}

"Plugs{{{
call plug#begin('~/.vim/plugged')
Plug 'VundleVim/Vundle.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'universal-ctags/ctags'
Plug 'yggdroot/indentline'
Plug 'skwp/vim-indexed-search'
Plug 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'will133/vim-dirdiff'
Plug 'lukhio/vim-mapping-conflicts'
Plug 'tpope/vim-repeat'
Plug 'cespare/vim-toml'
Plug 'majutsushi/tagbar'
Plug '~/.vim/bundle/svndiff'
Plug 'bitc/lushtags'
Plug 'vim-scripts/a.vim'
Plug 'McSinyx/vim-octave'
call plug#end()
"}}}

"General{{{
set t_Co=256    "terminal colors
set encoding=utf-8  "always us utf-8 encoding
set scrolloff=3     "show at least three lines above and below the cursor
set autoindent
set showmode
set showcmd
set hidden
" No alerts
set noerrorbells
set visualbell
set t_vb="
set ttyfast
set ruler   "show coordinates cursor
set backspace=indent,eol,start
set laststatus=2
set relativenumber    "display line number relative to cursor
set confirm   "ask for confirmation
"Decimal numbers
set nrformats=
set history=1000
set undolevels=1000   
set spelllang=en

"Save with root permission
cmap w!! w !sudo tee > /dev/null %

au FocusLost * :wa

let mapleader =","
inoremap jk <Esc> 

" Highlight dark background
set background=dark

" Copy and delete line without carriage return
nnoremap yA m`^y$<C-o>
nnoremap dA m`^d$<C-o>

" Disable Ex
map Q <Nop>
"}}}

"Change tab behaviour{{{
set tabstop=2 "visual spaces per tab
set shiftwidth=2
set softtabstop=2   "spaces per tab when editing
set expandtab   "tabs are spaces
set smarttab
"Specific language indentation
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype c setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
"}}}

"Folding{{{
set foldenable  "enable folding
set foldlevelstart=5 "most folds open
set foldmethod=indent
"}}}

"Tab completion{{{
set wildmenu
set wildmode=list:longest
"}}}

"Useful search options{{{
nnoremap / /\v
vnoremap / /\v
" Ignore case
set ignorecase
" Unless using cases
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
" No highlight
nnoremap <leader><space> :noh <cr> 
"Go to matching parentheses with tab
nnoremap <tab> %
vnoremap <tab> %
"}}}

"Handle long lines{{{
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=140
"}}}

"Movement{{{
"Allow mouse
set mouse=a

"Move vertically by visual line
nnoremap j gj
nnoremap k gk
"}}}

"Insert{{{
"One character insert with space
nmap <space> i <esc>r

"Insert blank line
autocmd CmdwinEnter * nnoremap <buffer> <Enter> <Enter>
map <Enter> O<ESC>
map <leader><Enter> o<ESC>
"}}}

"Copy/pasting{{{
"Paste mode with F12
set pastetoggle=<F12>

"Clipboard system
set clipboard=unnamedplus
"}}}

"Highlight last inserted text
nnoremap gV `[v`]

"Edit/reload vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>rv :so $MYVIMRC<CR>

"Swap directory{{{
set backup
set backupdir=~/.vim/backup/
"}}}

"Save and run script
nnoremap <silent> <leader>rp :w \| ! ./%<CR>

"{{{Language C

"Insert header guards{{{
"Adds the #define to protect h files when h files are created.
if has("autocmd")
    autocmd BufNewFile *.{h,hpp} call <SID>insert_c_gates()  
endif " has("autocmd")
function! s:insert_c_gates()
   let gatename = <SID>CreateNormalGateName()
   let filename = expand("%:t")
   execute "normal i#ifndef " . gatename
   execute "normal o#define " . gatename
   execute "normal Go#endif \n/* End of file " . filename . " */"
   normal kk
endfunction
function! s:CreateNormalGateName()
   let tmp = substitute(toupper(expand("%:t")), "\\.", "_", "g")
   return tmp
endfunction
"}}}

"Go beginning definition C function{{{
function! Def()
  ?^[^ \t#]
endfunction
command! Def call Def()
"}}}

"ctags and cscope search{{{
set tags=./tags,tags;$HOME
let g:ctags_statusline=1
let g:ctags_path="/home/users/jxla/magicsbas/1Hz/working/magicSBAS/af/tags"

function! Csc()
  cscope find c <cword>
endfunction
command! Csc call Csc()

function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    silent! exe "cs add " . db . " " . path
    set cscopeverbose
  " else add the database pointed to by environment variable
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
endfunction
au BufEnter /* call LoadCscope()

if executable('lushtags')
    let g:tagbar_type_haskell = {
        \ 'ctagsbin' : 'lushtags',
        \ 'ctagsargs' : '--ignore-parse-error --',
        \ 'kinds' : [
            \ 'm:module:0',
            \ 'e:exports:1',
            \ 'i:imports:1',
            \ 't:declarations:0',
            \ 'd:declarations:1',
            \ 'n:declarations:1',
            \ 'f:functions:0',
            \ 'c:constructors:0'
        \ ],
        \ 'sro' : '.',
        \ 'kind2scope' : {
            \ 'd' : 'data',
            \ 'n' : 'newtype',
            \ 'c' : 'constructor',
            \ 't' : 'type'
        \ },
        \ 'scope2kind' : {
            \ 'data' : 'd',
            \ 'newtype' : 'n',
            \ 'constructor' : 'c',
            \ 'type' : 't'
        \ }
    \ }
endif
"}}}

"}}}

"""""""""""""""PLUG-INS""""""""""""""
" Rainbow parentheses TODO: Might delete{{{
"let g:rainbow_conf = {
"\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
"\	'ctermfgs': ['darkgray', 'darkblue', 'darkmagenta', 'darkcyan'],
"\	'operators': '_,_',
"\	'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
"\	'separately': {
"\		'*': {},
"\		'lisp': {
"\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
"\			'ctermfgs': ['darkgray', 'darkblue', 'darkmagenta', 'darkcyan', 'darkred', 'darkgreen'],
"\		},
"\		'vim': {
"\			'parentheses': [['fu\w* \s*.*)','endfu\w*'], ['for','endfor'], ['while', 'endwhile'], ['if','_elseif\|else_','endif'], ['(',')'], ['\[','\]'], ['{','}']],
"\		},
"\		'tex': {
"\			'parentheses': [['(',')'], ['\[','\]'], ['\\begin{.*}','\\end{.*}']],
"\		},
"\		'css': 0,
"\		'stylus': 0,
"\	}
"\}

nmap <leader>p :RainbowParentheses!! <CR>
""}}}

"Solarized{{{
syntax enable
set background=dark " dark|light "
colorscheme solarized
"}}}

"Airline{{{
let g:airline_powerline_fonts = 1
"Correct vim8 bug
if !exists('g:airline_symbols')
let g:airline_symbols = {}
let &t_TI = ""
let &t_TE = ""
endif

"Clean indicators
let g:airline#extensions#whitespace#checks = [ 'trailing' ]
let g:airline#extensions#searchcount#enabled = 0

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

" old vim-powerline symbols
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
"}}}

"Tagbar{{{
nmap <F8> :TagbarToggle<CR>

command! -nargs=0 TagbarToggleStatusline call TagbarToggleStatusline()
function! TagbarToggleStatusline()
   let tStatusline = '%{exists(''*tagbar#currenttag'')?
            \tagbar#currenttag(''     [%s] '',''''):''''}'
   if stridx(&statusline, tStatusline) != -1
      let &statusline = substitute(&statusline, '\V'.tStatusline, '', '')
   else
      let &statusline = substitute(&statusline, '\ze%=%-', tStatusline, '')
   endif
endfunction
"}}}
"
"coc.nvim{{{
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
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

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

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
"}}}

"DiffW TODO: Not sure why I have this{{{
set diffopt+=iwhite
set diffexpr=DiffW()
function DiffW()
  let opt = ""
   if &diffopt =~ "icase"
     let opt = opt . "-i "
   endif
   if &diffopt =~ "iwhite"
     let opt = opt . "-w " " swapped vim's -b with -w
   endif
   silent execute "!diff -a --binary " . opt .
     \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
endfunction
"}}}

"Show function name in statusline {{{
function! ShortEcho(msg)
  " regular :echomsg is supposed to shorten long messages when shortmess+=T but it does not.
  " under "norm echomsg", echomsg does shorten long messages.
  let saved=&shortmess
  set shortmess+=T
  exe "norm :echomsg a:msg\n"
  let &shortmess=saved
endfunction

fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  let ms = getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bWn'))
  call ShortEcho(ms)
  echohl None
endfun
"}}}

"let g:Tex_Env_equation = "\\begin{equation}\<CR><++>\<CR>\\end{equation}<++>"
"Toggle gundo
"nnoremap <leader>u :GundoToggle<CR>
"set undofile

"Fold this .vimrc
set modelines=1
" vim:foldmethod=marker:foldlevel=0
