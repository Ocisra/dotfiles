" nnoremap <leader>av :!<CR>
nnoremap <buffer> <leader>au :!arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno
nnoremap <buffer> <leader>ac :!arduino-cli compile -fqbn arduino:avr:uno
