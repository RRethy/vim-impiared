" impiared.vim - auto closed your pairs
" Maintainer: Adam P. Regasz-Rethy (RRethy) <rethy.spud@gmail.com>


" TODO dont close pair if there is a word in front

if exists('g:loaded_impiared')
    finish
endif

let g:loaded_impiared = 1

let s:opening_chars = []
let s:closing_chars = []

fun! s:get_pairs() abort
    return get(g:, 'Impiared_pairs', [['(', ')'], ['{', '}'], ['[', ']']])
endf

fun! s:setup_pair(start, end) abort
    call add(s:opening_chars, a:start)
    call add(s:closing_chars, a:end)
    exe 'inoremap <expr> '.a:start.' <SID>open_pair("'.a:start.'","'.a:end.'")'
    exe 'inoremap <expr> '.a:end.' <SID>close_pair("'.a:end.'")'
endf

for pair in s:get_pairs()
    call s:setup_pair(pair[0], pair[1])
endfor

inoremap <expr> <backspace> <SID>do_backspace()
inoremap <expr> <CR>        <SID>do_carriage_return()

fun! s:open_pair(start, end) abort
    if col('$') - 1 >= col('.') && getline('.')[col('.') - 1] ==# a:end
        return a:start
    else
        return a:start.a:end."\<Left>"
    endif
endf

fun! s:close_pair(closing_char) abort
    if col('$') - 1 >= col('.') && getline('.')[col('.') - 1] ==# a:closing_char
        return "\<Right>"
    else
        return a:closing_char
    endif
endf

fun! s:do_backspace() abort
    let line = getline('.')
    if col('.') > 1
                \ && col('.') < col('$')
                \ && index(s:opening_chars, line[col('.') - 2]) != -1
        return "\<Del>\<backspace>"
    endif

    return "\<backspace>"
endf

fun! s:do_carriage_return() abort
    let line = getline('.')
    let col = col('.')
    for pair in s:get_pairs()
        if line[col-2] ==# pair[0] && line[col-1] ==# pair[1]
            return "\<CR>\<ESC>O"
        endif
    endfor
    return "\<CR>"
endf
