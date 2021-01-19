packadd termdebug
let g:termdebug_wide=163

noremap <F6> <Esc>:Termdebug
noremap <F5> <Esc>:Run<CR>
" Shift F5 is mapped to F17 in kitty
noremap <F17> <Esc>:Stop<CR>
noremap <F10> <Esc>:Over<CR>
noremap <F11> <Esc>:Step<CR>
noremap <F9> <Esc>:Break<CR>
" Shift F9 is mapped to F21 in kitty
noremap <F21> <Esc>:Clear<CR>

noremap <F7> <Esc>:!make

nnoremap <leader>gh :ClangdSwitchSourceHeader<CR>


let g:tagbar_type_c = {
    \ 'kinds' : [
        \ 'h:header files:1:0',
        \ 'd:macros:1:0',
        \ 'p:prototypes:1:0',
        \ 'g:enums',
        \ 'e:enumerators:0:0',
        \ 't:typedefs:0:0',
        \ 's:structs',
        \ 'u:unions',
        \ 'm:members:0:0',
        \ 'v:variables:0:0',
        \ 'f:functions',
        \ 'x:external:1:0',
        \ 'l:local:1:0',
        \ '?:unknown',
    \ ],
\ }
