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
    let lnum_cur = indent(nextnonblank('.')) > indent(prevnonblank('.')) ? nextnonblank('.') : prevnonblank('.')
    let stop_line = search('^\S', 'ncbW')
    let lnum_start = search('^\s*\.\.\%(\s\|$\)', "cbW", stop_line)
    if !lnum_start | return [0, 0] | endif
    while lnum_start && indent(lnum_start) >= s:min_indent(lnum_start + 1, lnum_cur)
        let lnum_start = search('^\s*\.\.\%(\s\|$\)', "bW", stop_line)
    endwh
    if !lnum_start | let lnum_start = line('.') | endif
    if indent(lnum_start) >= s:min_indent(lnum_start + 1, lnum_cur) | return [0, 0] | endif
    let lnum_end = search('\(^\s\{,' . indent(lnum_start) . '}\S\)\|\%$', "nW")
    if lnum_end
        if (lnum_end == line('$') && (getline(lnum_end) =~ '^\s*$' || indent(lnum_end) <= indent(lnum_start)))
              \ || lnum_end != line('$')
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
" .. _anchor1:
"
" ==============
" Section
" ==============
" contents of a section
"
" .. _anchor2:
"
" Another section
" ===============
"
" Internal hyperlink targets have empty link blocks. They provide an end point
" allowing a hyperlink to connect one place to another within a document. An
" internal hyperlink target points to the element following the target.
"
" In this case .. _anchor1: belongs to Section and .. _anchor2: to Another section
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
        if getline(prevnonblank('.')) =~ '^\s*\.\.\s\+_[^_[:space:]].*:\s*$'
            exe nextnonblank(line('.') + 1)
        endif
        normal! 0
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

        " check for the .. _anchor: and adjust start position
        if !a:inner && getline(prevnonblank(lnum_start - 1)) =~ '^\s*\.\.\s\+_[^_[:space:]].*:\s*$'
            let lnum_start = prevnonblank(lnum_start - 1)
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
                " lnum_start is wrong
                if lnum_start > lnum_end
                    return [0, 0]
                endif
                " lnum_start is an anchor to other section
                if getline(lnum_start) =~ '^\s*\.\.\s\+_[^_[:space:]].*:\s*$'
                      \ && lnum_start == lnum_end
                    return [0, 0]
                endif
            endif

            " check for the .. _anchor: and adjust end position
            if getline(prevnonblank(lnum_end)) =~ '^\s*\.\.\s\+_[^_[:space:]].*:\s*$'
                if a:inner
                    let lnum_end = prevnonblank(prevnonblank(lnum_end) - 1)
                else
                    let lnum_end -= 2
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


" gx to open URLs.
" - anonymous__
" - `anonymous link`__
" - namedlink_
" - `named link with spaces`_
" - `named link with <actual link name_>`_
" - naked urls
func! rst#gx() abort
    " URL regexes
    let rx_base = '\%(\%(http\|ftp\|irc\)s\?\|file\)://\S'
    let rx_bare = rx_base . '\+'
    let rx_embd = rx_base . '\{-}'

    let URL = ""

    " `Google search`__
    " Yandex__
    " ...
    " .. __: https://google.com
    " __ https://yandex.ru
    " Scan document from top to cursor position, find matching __
    try
        let save_view = winsaveview()
        let url_start = '\%(^\|[[:space:][\]()"' . "'" . '-:/]\)\zs`\ze[^`[:space:]]'
        let url_end = '\S`__\ze\%($\|[[:space:].,:;!?"' . "." . '/\\>)\]}]\)'
        if expand("<cfile>") =~ '^.*__$' || searchpair(url_start, '', url_end, 'ncbW') > 0
            let url_cnt = 0
            normal! go
            while search('\%(\<\S\{-}__\>\)\|\%(^\s*\%(__\s\+\S\+\)\|\%(\.\.\s\+__:\s\+\S\+\)\)', 'eW', save_view.lnum)
                if search('\<\S\{-}__\>', 'ncbW')
                    let url_cnt += 1
                else
                    let url_cnt -= 1
                endif
                if line('.') == save_view.lnum && col('.') > save_view.col
                    break
                endif
            endwhile
            while url_cnt > 0
                if search('^\s*\%(__\s\+\S\+\)\|\%(\.\.\s\+__:\s\+\S\+\)', 'eW')
                    let url_cnt -= 1
                else
                    break
                endif
            endwhile
            if !url_cnt && expand("<cfile>") =~ rx_bare
                let URL = expand("<cfile>")
            endif
        endif
    finally
        call winrestview(save_view)
    endtry

    " .. _`Google search`: https://google.com
    "
    " `Google search`_
    "
    " Yandex_
    "
    " `Google
    " search`_
    " ...
    " `Google        search`_
    " .. _Yandex: https://yandex.ru
    "
    "  angle brackets `exits through with-statements <issue 1270_>`_.
    "
    ".. _issue 1270: https://github.com/nedbat/coveragepy/issues/1270
    try
        let save_view = winsaveview()
        let url_start = '\%(^\|[[:space:][\]()"' . "'" . '-:/]\)\zs`\ze[^`[:space:]]'
        let url_end = '\S\zs`_\ze\%($\|[[:space:].,:;!?"' . "." . '/\\>)\]}]\)'
        let url_name = ''
        if empty(url_name)
            if col('.') > 2 && getline('.')[col('.') - 2 : col('.') + 2] =~ '`_'
                normal! 2h
            endif
            if searchpair(url_start, '', url_end, 'cbW') > 0
                let s_pos = getcurpos()
                if search('`_', 'W')
                    let e_pos = getcurpos()
                    if s_pos[1] == e_pos[1]
                        let url_name = getline('.')[s_pos[2] : e_pos[2] - 2]
                    elseif e_pos[1] - s_pos[1] == 1
                        let url_name = getline(line('.') - 1)[s_pos[2] : ]
                        let url_name .= ' ' . getline('.')[: e_pos[2] - 2]
                    endif
                    " Check for angle brackets `exits through with-statements <issue 1270_>`_
                    " and use it instead
                    let url_sub_name = matchstr(url_name, '<\zs.\{-}[^_]\ze_>')
                    if !empty(url_sub_name)
                        let url_name = url_sub_name
                    endif
                    let url_name = substitute(url_name, '\s\+', '\\s\\+', 'g')
                endif
            endif
        endif
        if !empty(url_name)
            normal! go
            if search('^\s*\.\.\s\+_\(`\)\?' . url_name . '\1:\s\+\S\+', 'eW')
                if expand("<cfile>") =~ rx_bare
                    let URL = expand("<cfile>")
                endif
            endif
        endif
        if empty(url_name) && expand("<cfile>") =~ '^.*[^_]_$' 
            let url_name = expand("<cfile>")[:-2]
        endif
    finally
        call winrestview(save_view)
    endtry

    if empty(URL)
        let URL = matchstr(expand("<cfile>"), rx_bare)
    endif

    if empty(URL)
        return
    endif

    call s:open(escape(URL, '#%!'))
endfunc


" Open URL in an OS
func! s:open(url) abort
    let url = a:url
    if exists("$WSLENV")
        lcd /mnt/c
        let cmd = ":silent !cmd.exe /C start"
    elseif has("win32") || has("win32unix")
        let cmd = ':silent !start'
    elseif executable('xdg-open')
        let cmd = ":silent !xdg-open"
    elseif executable('open')
        let cmd = ":silent !open"
    else
        echohl Error
        echomsg "Can't find proper opener for an URL!"
        echohl None
        return
    endif

    try
        echom cmd . ' "' . url . '"'
        exe cmd . ' "' . url . '"'
    catch
        echohl Error
        echomsg v:exception
        echohl None
    finally
        if exists("$WSLENV") | lcd - | endif
        redraw!
    endtry
endfunc
