set nu " Display line number
set autoindent " Indent automatically
set cindent " Auto-indent for C programming
set smartindent " Smart indent
"set nowrapscan "Don't go to the first line when scan the file
set ruler  "Display current cursor
set tabstop=4 " (ts=2) Tabsize
set shiftwidth=4 "Set width of auto indent (sw=2)
set softtabstop=4 "(sts=2) 
set showmatch "Highlight corresponding bracket
set history=256
set laststatus=4   "Always display status
"" The width and height of the vim window
"set co=84 " The width of the vim window
"set lines=50 " The height of the vim window
set mps+=<:> " Add the pair for < >
set mps+={:}  
set nopaste "To enable syntax assistance
set scrolloff=2
set expandtab " Input blank space instead of tab
set smarttab
set bs=eol,start,indent " Use backspace
set wmnu " Show the possible list when autofilling 
set fileencodings=utf-8,euc-kr " Set file encoding

set title
set autowrite
set autoread
set wildmode=longest,list

"""" Search Function Setting
set hlsearch "Highlighting Keyworkd
set incsearch " Searching starts after you enter the string
set ignorecase " case-insensitive search
set smartcase "smart case search - need <set ignore> to work properly

" listchars
"set list listchars=trailtab:»·,trail:·

" set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\

"" Make it red, when the line goes over 80
highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
match OverLength /\%81v.\+/

"Locate the cursor at the place exited last
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif
 
"Use syntax highlighting
if has("syntax")
  syntax on
endif

" File Encoding to Korean
if $LANG[0]=='k' && $LANG[1]=='o'
set fileencoding=korea
endif

" MapLeader
let mapleader = "\t" "tab as a leader key

" Position Mark
map <C-k>1 mA
map <C-k>2 mB
map <C-k>3 mC
map <C-k>4 mD
map <C-k>5 mE
map <C-k>6 mF
map <C-k>7 mG
map <C-k>8 mH
map <C-k>9 mI
 
map 11 :w<CR>'A
map 22 :w<CR>'B
map 33 :w<CR>'C
map 44 :w<CR>'D
map 55 :w<CR>'E
map 66 :w<CR>'F
map 77 :w<CR>'G
map 88 :w<CR>'H
map 99 :w<CR>'I
map `` :e#<CR>

" Shortcut
" map <c-a> :w<CR>

map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

" Open Header or Source file
map <s-a> <C-w>f <C-w>t <C-w>H
map <s-z> :vs %:r.cc<CR>
map <s-x> :vs %:r.h<CR>
" map <s-n> :vs %:r.cc<CR>
" map <s-m> :vs %:r.h<CR>

" Buffer Next/Previous
nnoremap <leader>l :bn<CR>
nnoremap <leader>h :bp<CR>

"" Set ctags to find the tag througbh the several directory 
function SetTags()
  let curdir = getcwd()
    while !filereadable("tags") && getcwd() != "/"
      cd ..
     endwhile
  if filereadable("tags")
  execute "set tags=" . getcwd() . "/tags"
  endif
  execute " cd " . curdir
endfunction
 
call SetTags()

"" Set cscope function to find the several tags
set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb
 
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if(!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppresss 'dubplicate connection ' error
    exe "cs add " . db . "" . path
    set cscopeverbose
   endif
endfunction
au BufEnter /* call LoadCscope()

" Copy to Clipboard"
set clipboard=unnamedplus

" CtrlP File Optimization
let g:ctrlp_custom_ignore = {
\ 'dir':  '\.git$\|public$\|log$\|tmp$\|vendor$\|bin$\|build$\|resource$',
\ 'file': '\v\.(exe|so|dll|o|png|)$'
\ }

let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_max_files = 10000000
let g:ctrlp_max_depth = 10000
 
" vim airline
set laststatus=2
let g:airline#extensions#powerline#enabled = 1
let g:airline_theme='base16'

 " tagbar configuration
map <C-O> :Tagbar<CR>
 " nerdtree configuration
map <C-E> :NERDTreeToggle<CR>
 " lightline configuration
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \ 'left' : [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
      \ }
      \ }
