"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                         "
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗                   "
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝                   "
"               ██║   ██║██║██╔████╔██║██████╔╝██║                        "
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║                        "
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗                   "
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝                   "
"                                                                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible
scriptencoding utf-8
set encoding=utf-8

" Only use the newline without carriage return.
set fileformat=unix

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Disable swap file creation.
set noswapfile

" Add markers to indicate tabs vs spaces.
set list listchars=eol:↵,tab:»\ ,trail:•,nbsp:⎵

" Add numbers to each line on the left-hand side.
set number
set relativenumber

" Allow seeing some lines below before cursor reaches end.
set scrolloff=5

" Highlight cursor line underneath the cursor horizontally.
set cursorline
hi CursorLine cterm=NONE ctermbg=234 ctermfg=NONE

" Highlight cursor line underneath the cursor vertically.
set cursorcolumn
hi CursorColumn cterm=NONE ctermbg=234 ctermfg=NONE

" Set line number color
highlight LineNr       ctermfg=DarkGreen guifg=DarkGreen
highlight CursorLineNr ctermfg=Green guifg=Green

" Set shift width for autocomplete.
set shiftwidth=2

" Set tab width.
set tabstop=2

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.jpeg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,*.mp3,*.mp4,*.out

" Color column to indicate line overflow.
set colorcolumn=120
highlight ColorColumn ctermbg=darkred guibg=darkred

" Color theme for tabs.
highlight TabLineFill ctermfg=234 ctermbg=DarkGreen
highlight TabLine     ctermfg=DarkGreen ctermbg=Black
highlight TabLineSel  ctermfg=White ctermbg=DarkGreen

" PLUGINS ---------------------------------------------------------------- {{{

" Plugin code goes here.
call plug#begin()
"
"   " List your plugins here
"   Plug 'tpope/vim-sensible'
"

" View file structure.
Plug 'preservim/nerdtree'

" Commenting code.
Plug 'tpope/vim-commentary'

" Linter and auto-formatter.
Plug 'dense-analysis/ale'

" Git commands in vim.
Plug 'tpope/vim-fugitive'

" For adding closing counterparts.
Plug 'tpope/vim-surround'

" Checking git diff.
if has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
endif

call plug#end()

" }}}


" MAPPINGS --------------------------------------------------------------- {{{

" Mappings code goes here.

let mapleader = " "

" Save the file mapping.
noremap <silent><C-s> :w<CR>
noremap <silent><Tab><Right> :tabn<CR>
noremap <silent><Tab><Left> :tabp<CR>
noremap <Tab><N> :tabnew<CR>

" NERDTree mappings go here.
nnoremap <silent><F2> :NERDTreeToggle<CR>

" Faster sign updates on CursorHold/CursorHoldI
set updatetime=100

" Check git diff in file.
nnoremap <silent>]d :SignifyHunkDiff<CR>
nnoremap <silent>]u :SignifyHunkUndo<CR>

" Good for entering stage commit.
nnoremap <silent><S-G> :tab Git<CR>

" Add a git blame on selected line.
noremap <silent><S-C> :call setbufvar(winbufnr(popup_atcursor(systemlist("cd " . shellescape(fnamemodify(resolve(expand('%:p')), ":h")) . " && git log --no-merges -n 1 -L " . shellescape(line("v") . "," . line(".") . ":" . resolve(expand("%:p")))), { "padding": [1,1,1,1], "pos": "botleft", "wrap": 0 })), "&filetype", "git")<CR>

" Add surround command shortcut.
vnoremap s <Plug>VSurround

" Toggle comments.
nnoremap <silent><C-_> <Plug>CommentaryLine
vnoremap <silent><C-_> <Plug>Commentary

" Go to definitions and references.
nnoremap <silent><F3> :ALEGoToDefinition -tab<CR>
nnoremap <silent><S-F3> :ALEFindReferences -split -relative<CR>
nnoremap <silent><S-D> :ALEHover<CR>
nnoremap <silent><S-F> :ALEFix<CR>

" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{

function! GetMode()
  let l:mode = mode()
  if l:mode == 'n'
    return 'NORMAL'
  elseif l:mode == 'i'
    return 'INSERT'
  elseif l:mode == 'v' || l:mode == 'V' || l:mode == 'CTRL-V'
    return 'VISUAL'
  elseif l:mode == 'c'
    return 'COMMAND'
  else
    return 'UNKNOWN'
  endif
endfunction

" This will enable code folding for vim files.
" Use the marker method of folding.
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
  set undodir=~/.vim/backup
  set undofile
  set undoreload=10000
endif

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

let NERDTreeShowHidden=1
let NERDTreeMinimalUI  = 1
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']
let g:NERDTreeQuitOnOpen = 1

" Enable completion where available.
let g:ale_completion_enabled = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}

let g:ale_floating_preview = 1
let g:ale_set_quickfix = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_delay = 1000
let g:ale_fix_on_save = 0

highlight SignColumn        ctermbg=234 ctermfg=White
highlight SignifySignAdd    ctermfg=green  cterm=NONE
highlight SignifySignDelete ctermfg=red    cterm=NONE
highlight SignifySignChange ctermfg=yellow cterm=NONE
highlight Pmenu             ctermbg=236 ctermfg=white
highlight PmenuSbar         ctermbg=grey

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Status bar code goes here.

" Active window status line
highlight EditStatusLine     ctermfg=black ctermbg=green
highlight RightStatusLineOne ctermfg=green ctermbg=232
highlight FileStatusLine     ctermfg=green ctermbg=234
highlight RightStatusLineTwo ctermfg=lightgreen ctermbg=234
highlight PercentStatusLine  ctermfg=black ctermbg=green
highlight NoneStatusLine     ctermfg=NONE ctermbg=NONE

set laststatus=2

set statusline=
set statusline+=%#EditStatusLine#\ %{GetMode()}\  " Show vim edit mode
set statusline+=%#FileStatusLine#\ %t:%l-%c\  " Full path to file with current line and column number
set statusline+=%m " Modified flag ([+])
set statusline+=%r " Read-only flag (RO)
set statusline+=%= " Aligns the following items to the right
set statusline+=%#RightStatusLineTwo#\ %{FugitiveStatusline()}\  "Add git information
set statusline+=%#RightStatusLineOne#\ %{&filetype}\  " Percentage through file
set statusline+=%#RightStatusLineTwo#\ %{''.(&fenc!=''?&fenc:&enc).''}\  "Encoding
set statusline+=%#RightStatusLineOne#\ TL:%L\ VC:%v\ %P\  "Percentage through file.

" }}}
