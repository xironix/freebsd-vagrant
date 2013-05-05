"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=1000

" Set to auto read when a file is changed from the outside
set autoread

" We want iMproved
set nocompatible


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Increase number of tabs
set tabpagemax=20

" Set lines to the cursor - when moving vertically using j/k
set so=4

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Configure backspace so it acts as it should act
set backspace=indent,eol,start
set whichwrap+=<,>,h,l

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
autocmd VimEnter * set vb t_vb=
set tm=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

if has("gui_running")
    " Highlight the current line
    set cursorline

    " Use a smaller font
    set guifont=DejaVu\ Sans\ Mono\ 8

    " Use a larger default window
    set columns=100 lines=50
else
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

set laststatus=2    " Always display the statusline in all windows
set noshowmode      " Hide the default mode text (e.g. -INSERT-)
set t_Co=256        " Force 256 colour mode
set number          " Number lines


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab
set autoindent
set smartindent

" 1 tab == 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Wrap Text
set wrap

" display indentation guides
set list
set listchars=tab:¦\-,trail:·,extends:»,precedes:«,nbsp:×

" Display a vetical column
set colorcolumn=80

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Delete trailing white space
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

" Automatically delete training white space on save
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" Enable Ctrl+C and Ctrl+V for the clipboard
map <C-V> "+gP
map <C-X> "+x
cmap <C-V> <C-R>+
vnoremap <C-C> "+y

" Set t for next tab and T for previous tab
map t <Esc>:tabnext<CR>
map T <Esc>:tabprev<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom behaviour by file type
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufRead,BufNewFile Makefile* set noexpandtab nolist
au BufRead,BufNewFile COMMIT_EDITMSG set noexpandtab nolist
au BufRead,BufNewFile /etc/rsnapshot.d/*.conf set noexpandtab nolist
au BufRead,BufNewFile *.py set shiftwidth=4 tabstop=4
au BufRead,BufNewFile *.md set tw=80 lbr
au BufRead,BufNewFile *.markdown set tw=80 lbr
au BufRead,BufNewFile *.tex set tw=0 wrapmargin=0 linebreak nolist

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle bundles =D
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle Requirements
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage itself
Bundle 'gmarik/vundle'

" Custom colorscheme
Bundle 'xironix/zarniwoop.vim'
colorscheme zarniwoop
highlight Normal  ctermfg=none ctermbg=none
highlight LineNr               ctermbg=none
highlight NonText              ctermbg=none

" Fancy status line
Bundle 'Lokaltog/vim-powerline'
let g:Powerline_symbols = 'unicode'

" Git integration
Bundle 'tpope/vim-fugitive'

" Markdown syntax
Bundle 'tpope/vim-markdown'

" NERD Tree!
Bundle 'scrooloose/nerdtree'

" Syntastic
Bundle 'scrooloose/syntastic'

" Python Syntax
Bundle 'python.vim'

" Puppet Syntax
Bundle 'rodjek/vim-puppet'

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
