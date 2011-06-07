set ruler
set expandtab shiftwidth=4 tabstop=4 softtabstop=4
set wildmenu wildmode=longest:full,full
set incsearch nohlsearch
set hidden
set mouse=a
set laststatus=2

set showcmd
let g:full_name="Maxime Coste"

set title
set termencoding=utf-8

filetype plugin indent on
syntax on

" use tagjump behaviour by default
nnoremap <C-]> g<C-]>
nnoremap <C-W><C-]> <C-W>g<C-]>
nnoremap <C-W>] <C-W>g]

" reload vimrc when modified
autocmd! BufWritePost .vimrc source %

" C/C++ Options
autocmd FileType c\|cpp setlocal cindent
set cinoptions=:0,g0,(0,w0,Ws

let g:clang_complete_auto = 0

function! InsertGuards() 
    let define = substitute(substitute(expand('%'), "^.*/", "", ""), "[-\\/. ]", "_", "g") . "_INCLUDED"
    call append(0, [ "#ifndef " . define, "#define " . define, ])
    call append(line("$"), "#endif // " . define)
    if line("$") == 3
        call append(2, "")
        call cursor(3, 0)
    endif
endfunction

augroup Cpp
    autocmd!
    autocmd FileType cpp syn keyword cppKeywords2 override sealed offsetof
    autocmd FileType cpp hi link cppKeywords2 Keyword
    autocmd BufNewFile *.{h,hh,hpp} call InsertGuards()
augroup end

" connect to cscope.out if possible
if filereadable("cscope.out")
    cscope add cscope.out
endif

" Background make
command! -nargs=* BgMake
    \ silent execute ":!(make " . "<args>" . " > /tmp/make.output 2>&1;"
                   \ "notify-send 'make finished' 'make <args> finished') &" |
    \ redraw! |
    \ cfile /tmp/make.output | copen

" Mr Proper stuffs
augroup Whitespace
    autocmd!
    autocmd Syntax * syn match TrailingWhitespace /\s\+$/
    autocmd Syntax * hi  link TrailingWhitespace Error
augroup end

function! FixBlanks()
    %s/\s\+$//
    retab
endfunction

command! FixBlanks call FixBlanks()

" Eugen Systems stuff
augroup Eugen
    autocmd!
    autocmd VimEnter * if match(getcwd(), "slayer") != -1 |
        \set tags+=datatags |
    \endif
    autocmd VimEnter * if match(getcwd(), "slayer") != -1 |
    autocmd BufNewFile *.cpp if match(getcwd(), "slayer") != -1 |
        \call append(0, "#include \"StdAfx.h\"") |
    \endif
augroup end

function! FixIncludeMistake(mistake, correction) abort
    exec "vimgrep /^ *# *include \\+.*".a:mistake."/ Projects/**/*.cpp Projects/**/*.h"
    while 1
        exec "s/".a:mistake."/".a:correction."/g"
        cn
    endwhile
endfunction

" AutoComplPop
let g:acp_enableAtStartup = 1
let g:acp_ignorecaseOption=0

" man support
runtime ftplugin/man.vim
nnoremap K :Man <C-R><C-W><CR>

colorscheme wombat256
