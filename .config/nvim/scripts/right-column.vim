" This script right-align a table in column
" e.g. (with default settings)
" {                             >   {
" item, item, item              >       item,         item, item,
" longitem,    verylongitem,    >   longitem, verylongitem,
" i, ii, iii,                   >          i,           ii,  iii,
"    }                          >   }
"



" pattern that is matched as beginning/end of word, the rest of the world can
" be every printable ASCII character (except space), unbreakable space and
" unicode latin-1 supplement (except symbols and punctuation)
" next line is an old version, keep in case for now even if new one seems safer
" let s:wordBoundariesPattern="[a-zA-Z0-9_&*\\\"'\\(\\){}\\[\\],;]"
let s:wordBoundariesPattern="\\S"

" include or not the first and last line in the formatting
" if set to 0, will ignore 's:alignBrackets'
let s:includeFirstAndLastLine=1

" keep or not the indent of the opening bracket
" 0 : align leftmost, the more width-compact
" 1 : align with the opening bracket, the more dangerous (bracket at eol)
" 2 : align with the line containing the opening bracket, classic
let s:offset=2

" align or not the opening and closing brackets
" if set to non-zero, won't format the line containing the opening bracket if
" it is the last word of its line, same for the closing one if its the last.
" if both are not formatted, it will align the closing one and the opening one
let s:alignBrackets=1

" the minimum number of spaces between two fields 
let s:minSpace=2



function! s:rightAlign() abort

    let l:skipOpening = 0
    let l:skipClosing = 0

    " go to beginning of table
    call search("{", "bce")

    " check if the first line should be formatted
    if s:alignBrackets && search("{\\s*\\_$", "czn", line(".")) && s:includeFirstAndLastLine
        let l:openingColumn = col(".")
        let l:skipOpening = 1
    endif

    
    if s:offset == 1
        let l:indentOffset = col(".") - 1
    elseif s:offset == 2
        let l:curcol = col(".")
        call cursor(line("."), 1)
        " search first word of line
        let l:indentOffset = searchpos(s:wordBoundariesPattern, "cn", line("."))[1] - 1
        call cursor(line("."), l:curcol)
    endif

    " 'searchpairpos()' move to the matched bracket, can be avoid with 'n'
    " flag but it doesn't matter 
    let l:lineNumber = - line(".") + searchpairpos('{','','}')[0] + 1
    if l:lineNumber <= 0
        return
    endif

    " because we are at the end we can check now if the last line should be
    " formatted, else it would have been between the two passes
    if s:alignBrackets && search("\\_^\\s*}", "bcn", line(".")) && s:includeFirstAndLastLine
        let l:skipClosing = 1
    endif

    let l:maxwidth = [] " contain the width of the longest field of each column

    " remove first and last lines from the count if necessary and move to
    " beginning of first line to treat  
    if !s:includeFirstAndLastLine
        let l:lineNumber -= 2
        call cursor(line(".") - 1, 1)
    else
        call cursor(line("."), 1)
    endif

    if l:lineNumber <=  0 " can't format 0 line
        return
    endif

    
    " fill 'l:maxwidth'
    " starts from the end (that is where the cursor is) go to the first word,
    " check it's length and eventually change 'l:maxwidth', go to next word...,
    " repeat until end of line, go to previous line..., repeat until first
    " line has been treated
    for i in range(1, l:lineNumber)
        " it is in fact the index in 'l:maxwidth' so, before being at the
        " first word (index 0), it should be -1
        let l:wordCount = -1 

        " skip the opening bracket according to 's:alignBrackets'
        if l:skipOpening && i == l:lineNumber
            continue
        endif

        " skip the closing bracket according to 's:alignBrackets' 
        if l:skipClosing && i == 1
            call cursor(line(".")-1, 1)
            continue
        endif

        while 1
            " search for next field
            let l:res = search(s:wordBoundariesPattern, "cez", line("."))
            if l:res == 0 
                " field not found, go to next line
                break
            endif

            let l:wordCount += 1

            let l:len = strlen(expand("<cword>")) " length of field

            " if the field is longer than than the previous longer one, replace
            " the corresponding 'l:maxwidth' value
            if l:len > get(l:maxwidth, l:wordCount, -1)
                " create the element if it does not exists
                if len(l:maxwidth) <= l:wordCount
                    call add(l:maxwidth, 0)
                endif
                let l:maxwidth[l:wordCount] = l:len
            endif

            call cursor(line("."), col(".") + l:len) " go to end of word

            if search(s:wordBoundariesPattern, "nz", line(".")) == 0
                " no more words, go to next line
                break
            endif
        endwhile

        " go to next line only if it is not the last, else the cursor would
        " end on a line that is not to be treated, if the table is at the very
        " beginning of a file, the cursor won't move causing uncertainties
        " about its position
        if i != l:lineNumber
            call cursor(line(".")-1, 1)
        endif
    endfor



    " indent according to 'l:maxwidth'
    " start at beginning (that is where the cursor is) go to first word,
    " replace the spaces in front of it with the desired number, go to next
    " word..., repeat until end of line, go to next line..., repeat until last
    " line has been treated
    for i in range(1, l:lineNumber)

        " skip the opening bracket according to 's:alignBrackets'
        if l:skipOpening && i == 1
            call cursor(line(".")+1, 1)
            continue
        endif

        " skip closing bracket according to 's:alignBrackets'
        if l:skipClosing && i == l:lineNumber
            if l:skipOpening " align opening and closing brackets
                execute "substitute/\\_^\\s*/".repeat(' ', l:indentOffset)."/"
            endif
            continue
        endif 

        " insert one space at beginning of line if there is none, workaround a bug
        " only works for single-byte charcater
        if getline(".")[col(".")-1] =~ s:wordBoundariesPattern
            execute "substitute/^/ /"
        endif

        " it is in fact the index in 'l:maxwidth' so, before being at the
        " first word (index 0), it should be -1
        let l:wordCount = -1

        " go to next word, retrieve its length, deduce the number of space to
        " insert, go back to beginning of the spaces before this word,
        " replaces the spaces with the good number, re-go to the beginning of
        " the word, go to end, repeat until end of line
        while 1
            " search for next field
            let l:res = search(s:wordBoundariesPattern, "cez", line("."))
            if l:res == 0
                " field not found, go to next line
                break
            endif

            let l:wordCount += 1 
            let l:len = strlen(expand("<cword>")) " length of field
            
            call cursor(line("."), col(".") - 1) " go to first whitespace from end

            if l:wordCount == 0
                " if first word of line, can't go back to previous word
                " just go to beginning of line
                call cursor(line("."), 1)
            else
                " go back to last non-whitespace
                call search(s:wordBoundariesPattern, "be", line("."))
                call cursor(line("."), col(".") + 1)
            endif

            " save column because 'substitute' has a ending column i don't understand
            let l:curcol = col(".")
            execute "substitute/\\%".col(".")."c\\s\\+/".
                        \ repeat(' ', l:maxwidth[l:wordCount] - l:len + 
                        \ ((l:wordCount == 0 && s:offset) ? l:indentOffset : s:minSpace)).
                        \ "/"
            call cursor(line("."), l:curcol) " restore column

            " go to beginning of word
            call search(s:wordBoundariesPattern, "ez", line("."))
            " go to end of word
            call cursor(line("."), col(".") + l:len)

            if search(s:wordBoundariesPattern, "nz", line(".")) == 0
                " no more words, go to next line
                break
            endif
        endwhile

        " go to next line only if it is not the last, just to stay on the part
        " of code we edited, else it won't break anything, it is just more
        " coherent
        if i != l:lineNumber
            call cursor(line(".")+1, 1)
        endif
    endfor

    return
endfunction

" set of characters to be considered as part of the same item
" e.g.  my_function(arg) or table[0] are recognized as 1 item each and not 2
" note  my_function(arg, other_arg) is recognized as 2 items because of the
"       space, this isn't a problem as pretty formatting lists of function
"       with arguments is rare, if it does happen
let s:savekeyword = &iskeyword
"                         vvvvvvv latin-1 supplement minus symbols
setlocal iskeyword=33-126,192-255
"                  ^^^^^^ printable ASCII minus space

call s:rightAlign()

let &iskeyword = s:savekeyword " restore settings
