" Directive text object:
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
func! rst#directive_tobj(inner) abort
    let lnum_cur = nextnonblank('.')
    let stop_line = search('^\S', 'ncbW')
    let lnum_start = search('^\s*\.\.\%(\s\|$\)', "cbW", stop_line)
    if !lnum_start | return | endif
    while lnum_start && indent(lnum_start) >= s:min_indent(lnum_start+1, lnum_cur)
        let lnum_start = search('^\s*\.\.\%(\s\|$\)', "bW", stop_line)
    endwh
    if !lnum_start | let lnum_start = line('.') | endif
    let lnum_end = search('\(^\s\{,'.indent(lnum_start).'}\S\)\|\%$', "nW")
    if lnum_end
        if (lnum_end == line('$') && getline(lnum_end) =~ '^\s*$') || lnum_end != line('$')
            let lnum_end = prevnonblank(lnum_end - 1)
        endif
        if a:inner
            let lnum_start = nextnonblank(lnum_start + 1)
            if lnum_start > lnum_end
                return
            endif
        endif
        exe lnum_end
        normal! V
        exe lnum_start
    endif
endfunc

func! s:min_indent(start, end) abort
    let lnums = filter(range(a:start, a:end), {_,lnum -> !empty(getline(lnum))})
    return min(map(lnums, {_,lnum -> indent(lnum)}))
endfunc


"" Jump to next/previous section
func! rst#section(back, cnt)
    let delims = '[=`:."' . "'" . '~^_*+#-]'
    let section = '\v^%(%([=-]{3,}\s+[=-]{3,})\n)@<!.+\n(' . delims . ')\1*$'
    normal! m`
    for n in range(a:cnt)
        call search(section, a:back ? 'bW' : 'W')
    endfor
endfunc
