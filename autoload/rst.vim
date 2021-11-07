" Jump to next/previous section
func! rst#section(back, cnt)
    let delims = '[=`:."' . "'" . '~^_*+#-]'
    let section = '\v^%(%([=-]{3,}\s+[=-]{3,})\n)@<!.+\n(' . delims . ')\1*$'
    normal! m`
    for n in range(a:cnt)
        call search(section, a:back ? 'bW' : 'W')
    endfor
endfunc

" Environment text object (either directive or a section)
" NOTE: section does not include subsections
func! rst#environment_tobj(inner) range abort
    let lnum_cur = line('.')
    let [lnum_dstart, lnum_dend] = s:directive_tobj(a:inner)
    let [lnum_sstart, lnum_send] = s:section_tobj(a:inner)

    if lnum_dstart == 0 && lnum_sstart == 0
        return
    endif

    if a:inner
        if lnum_dstart > lnum_sstart
            let lnum_start = lnum_dstart
            let lnum_end = lnum_dend
        else
            let lnum_start = lnum_sstart
            let lnum_end = lnum_send
        endif
    else
        if lnum_dstart > lnum_sstart && lnum_cur != lnum_dstart
            let lnum_start = lnum_dstart
            let lnum_end = lnum_dend
        else
            let lnum_start = lnum_sstart
            let lnum_end = lnum_send
        endif
    endif

    if lnum_end
        exe lnum_end
        normal! V
        exe lnum_start
    endif
endfunc


" Directive text object helper:
"
" .. directive::
"
"   contents of a directive
"
"   .. another_directive::
"
"     contents of
"     another directive
"
" Returns [lnum_start, lnum_end]
func! s:directive_tobj(inner) abort
    let lnum_cur = nextnonblank('.')
    let stop_line = search('^\S', 'ncbW')
    let lnum_start = search('^\s*\.\.\%(\s\|$\)', "cbW", stop_line)
    if !lnum_start | return [0, 0] | endif
    while lnum_start && indent(lnum_start) >= s:min_indent(lnum_start + 1, lnum_cur)
        let lnum_start = search('^\s*\.\.\%(\s\|$\)', "bW", stop_line)
    endwh
    if !lnum_start | let lnum_start = line('.') | endif
    let lnum_end = search('\(^\s\{,' . indent(lnum_start) . '}\S\)\|\%$', "nW")
    if lnum_end
        if (lnum_end == line('$') && getline(lnum_end) =~ '^\s*$') || lnum_end != line('$')
            let lnum_end = prevnonblank(lnum_end - 1)
        endif
        if a:inner
            let lnum_start = nextnonblank(lnum_start + 1)
            if lnum_start > lnum_end
                return [0, 0]
            endif
        endif
        return [lnum_start, lnum_end]
    endif
    return [0, 0]
endfunc


" Section text object helper:
"
" ==============
" Section
" ==============
" contents of a section
"
"   .. another_directive::
"
"     contents of
"     another directive
"
" Another section
" ===============
"
" Returns [lnum_start, lnum_end]
func! s:section_tobj(inner) abort
    try
        let save_cursor = getcurpos()
        let delims = '[=`:."' . "'" . '~^_*+#-]'
        let section_double = '\%(^\(' . delims . '\)\1*\n.\+\n\1\+$\)'
        let section_single = '\%(^\%(\%([=-]\{3,}\s\+[=-]\{3,}\)\n\)\@<!\%(\.\.\)\@!\S\+.*\n\(' . delims . '\)\2*$\)'
        let section = section_double . '\|' . section_single
        if getline('.') =~ '^\(' . delims . '\)\1*$'
            if getline(line('.') + 1) !~ '^\(' . delims . '\)\1*$'
                +1
            else
                -1
            endif
        endif
        let lnum_start = search(section, "cbW")
        if !lnum_start | return [0, 0] | endif
        if getline(lnum_start) !~ '^\(' . delims . '\)\1*$'
              \ && getline(lnum_start - 1) =~ '^\(' . delims . '\)\1*$'
            let lnum_start -= 1
        endif
        if getline(lnum_start) =~ '^\(' . delims . '\)\1*$'
            +3
        else
            +2
        endif
        let lnum_end = search('\%(' . section . '\)\|\%$', "cW")
        if lnum_end
            if (lnum_end == line('$') && getline(lnum_end) =~ '^\s*$') || lnum_end != line('$')
                if a:inner
                    let lnum_end = prevnonblank(lnum_end - 1)
                else
                    let lnum_end -= 1
                endif
            endif
            if a:inner
                if getline(lnum_start) =~ '^\(' . delims . '\)\1*$'
                    let lnum_start = nextnonblank(lnum_start + 3)
                else
                    let lnum_start = nextnonblank(lnum_start + 2)
                endif
                if lnum_start > lnum_end
                    return [0, 0]
                endif
            endif
            return [lnum_start, lnum_end]
        endif
        return [0, 0]
    finally
        call setpos('.', save_cursor)
    endtry
endfunc


func! s:min_indent(start, end) abort
    let lnums = filter(range(a:start, a:end), {_,lnum -> !empty(getline(lnum))})
    return min(map(lnums, {_,lnum -> indent(lnum)}))
endfunc
