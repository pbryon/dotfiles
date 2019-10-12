set nowrap
set tabstop=4
set expandtab
set backspace=indent,eol,start
set autoindent
set copyindent
set number
set shiftwidth=4
set shiftround
set showmatch
set smartcase
set hlsearch
set incsearch
set visualbell
colors molokai
set t_Co=256

set diffopt+=iwhite
set diffexpr=""

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Remove trailing whitespace
function TrimWhitespace()
    :s/\s\+$//e
endfunction
autocmd BufWritePre *.md :call TrimWhitespace()
