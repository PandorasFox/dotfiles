map <Leader>t :split +res\ 15 term://zsh <CR>
tnoremap <ESC> <C-\><C-n>
let $IN_NEOVIM = "yes"
highlight TermCursor ctermfg=red guifg=red

call plug#begin('~/.vim/plugged')

" https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" https://github.com/maralla/completor.vim
Plug 'maralla/completor.vim'
" https://github.com/scrooloose/nerdtree
" Plug 'scrooloose/nerdtree'
" https://github.com/scrooloose/nerdcommenter
" Plug 'scrooloose/nerdcommenter'
": Floobits/floobits-neovim
" Plug 'Floobits/floobits-neovim'
"
"Plug 'crusoexia/vim-monokai'
"
" Plug 'mfulz/cscope.nvim'
call plug#end()

" use the same Python 3 as python3-nvim
let g:python3_host_prog='/usr/bin/python3'
" same for Python 2
let g:python_host_prog='/usr/bin/python2'

" let g:cscope_map_keys = 1
let g:completor_clang_binary = '/bin/clang'
let g:completor_clang_disable_placeholders = 1

" airline stuff

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'laederon'
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#syntastic#enabled = 1

function! g:AirlineThemePatch(palette)
    if g:airline_theme == 'laederon'
      let a:palette.normal_modified = { 'airline_a' : [ '#ffffff' , '#777470' , 255 , 240 , '' ] }
      let a:palette.insert_modified = { }
    endif
endfunction

let g:airline_theme_patch_func = 'AirlineThemePatch'

let g:airline_section_b = '%{getcwd()}'
"let g:airline_section_c = '%t'

source ~/.vim/shared.rc
