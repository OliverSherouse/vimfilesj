" Built-In Functionality
"" General
let mapleader = ','

set hidden " Allow background buffers without saving
set spell spelllang=en_us
set splitright " Split to right by default
set backupcopy=yes " Copy to backup (for Parcel file-watcher)

"" Text Wrapping
" set textwidth=80
set colorcolumn=81
set nowrap

"" Search and Substitute
set gdefault " use global flag by default in s: commands
set nohlsearch " highlight searches
set ignorecase 
set smartcase " don't ignore capitals in searches

"" Tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab


"" Folding
set foldmethod=syntax

"" Matching
packadd! matchit



"" Backup, Swap and Undo
set undofile " Persistent Undo
if has("win32")
    set directory=$HOME\vimfiles\backup,$TEMP
    set backupdir=$HOME\vimfiles\backup,$TEMP
    set undodir=$HOME\vimfiles\backup,$TEMP
else
    set directory=~/.vim/backup,/tmp
    set backupdir=~/.vim/backup,/tmp
    set undodir=~/.vim/undo,/tmp
endif

""" NetRW
let g:netrw_liststyle=3 " Detail View
let g:netrw_sort_by="exten"
let g:netrw_sizestyle = "H" " Human-readable file sizes
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+' " hide dotfiles
let g:netrw_hide = 1 " hide dotfiles by default
let g:netrw_banner = 0 " Turn off banner

""" Explore in vertical buffer
nnoremap <Leader>e :Explore! <enter>

"" Mappings
nnoremap ; :
nnoremap <C-H> :bp <enter>
nnoremap <C-L> :bn <enter>
nnoremap <Leader>w :w <enter>
nnoremap <Leader>q :bd <enter>

nnoremap <silent> ]c :cnext <enter>
nnoremap <silent> [c :cprev <enter>
nnoremap <silent> ]l :lnext <enter>
nnoremap <silent> [l :lprev <enter>

noremap <Leader>x "+

"" Quickfix
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
augroup END

"" AutoFormat

function! AutoFormat()
    if &l:formatprg !=? ""
        :mark Q
        :normal gggqG
        :normal g'Q
        :delm Q
    endif
endfunction

augroup autoformat
    autocmd!
    autocmd BufWritePre * call AutoFormat()
augroup END

"" Lint

augroup autolint
    autocmd!
    autocmd BufWritePost * if exists('b:linter') | execute ":Dispatch ".b:linter." %" | endif
augroup END

"" Poetry

if file_readable('.venv/bin/activate')
    let $PATH = trim(system('pwd'))."/.venv/bin:".$PATH
elseif file_readable('pyproject.toml')
    let $PATH = trim(system('poetry env info -p'))."/bin:".$PATH
endif


" Plugins 

"" Installation with VimPlug
if has("win32")
    call plug#begin('~/vimfiles/plugged')
else
    call plug#begin('~/.vim/plugged')
endif


""" Basics
Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
Plug 'flazz/vim-colorschemes'
Plug 'Konfekt/vim-compilers'

""" General Functionality
Plug 'lifepillar/vim-mucomplete'
Plug 'MarcWeber/vim-addon-mw-utils' " for Snipmate
Plug 'tomtom/tlib_vim' " for Snipmate
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'Konfekt/FastFold'

""" Compilers

Plug 'salomvary/vim-eslint-compiler'

""" Particular Functionality
Plug 'davidhalter/jedi-vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'godlygeek/tabular'
Plug 'vimoutliner/vimoutliner'
Plug 'tmhedberg/SimpylFold'

call plug#end()

"" Colors
set termguicolors
colorscheme darth

"" Autocompletion
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,noinsert,noselect
set shortmess+=c " Turn off completion messages

let g:mucomplete#enable_auto_at_startup = 1 
let g:mucomplete#buffer_relative_paths = 1

"" Snippets

let g:snipMate = {}
let g:snipMate = { 'snippet_version' : 1 }
let g:snipMate['no_match_completion_feedkeys_chars'] = ''
let g:snipMate['description_in_completion'] = 1

call insert(g:mucomplete#chains['default'], 'snip')

imap <expr> <c-j> (pumvisible()?"\<c-y>":"")."\<plug>snipMateNextOrTrigger"
imap <expr> <c-k> <plug>snipMateBack

"" Goyo & Limelight
augroup goyo_limelight
    autocmd!
    autocmd User GoyoEnter Limelight
    autocmd User GoyoLeave Limelight!
augroup END

"" Pandoc
augroup pandoc_syntax
    autocmd!
    autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
    autocmd BufNewFile,BufFilePre,BufRead *.markdown set filetype=markdown.pandoc
augroup END

let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#codeblocks#embeds#langs = ['python', 'vim', 'make',
            \  'bash=sh', 'html', 'css', 'scss', 'javascript']

"" Snakemake

augroup snakemake
    autocmd! 
    autocmd BufNewFile,BufRead Snakefile set syntax=snakemake
    autocmd BufNewFile,BufRead *.smk set syntax=snakemake
augroup END

let g:SimpylFold_fold_docstring = 0

" R
let r_indent_align_args = 0
