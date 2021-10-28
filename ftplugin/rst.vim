if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let undo_opts = "setl flp< com<"

let undo_maps = "| execute 'nunmap <buffer> ]]'"
            \. "| execute 'nunmap <buffer> [['"

if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= "|" . undo_opts . undo_maps
else
    let b:undo_ftplugin = undo_opts . undo_maps
endif

setlocal comments=

let &l:formatlistpat = '^\s*\%('
let &l:formatlistpat .= '\%([-+*]\)'
let &l:formatlistpat .= '\|'
let &l:formatlistpat .= '\%(\d\+[.)]\)'
let &l:formatlistpat .= '\|'
let &l:formatlistpat .= '\%((\d\+)\)'
let &l:formatlistpat .= '\|'
let &l:formatlistpat .= '\%(\%(\a\|#\)[.)]\)'
let &l:formatlistpat .= '\|'
let &l:formatlistpat .= '\%((\%(\a\|#\))\)'
let &l:formatlistpat .= '\|'
let &l:formatlistpat .= '\%(|\)'
let &l:formatlistpat .= '\)\s\+'

nnoremap <silent><buffer> ]] :<c-u>call <sid>section(0, v:count1)<CR>
nnoremap <silent><buffer> [[ :<c-u>call <sid>section(1, v:count1)<CR>

"" Next/Previous section mappings
func! s:section(back, cnt)
    let delims = '[=`:."' . "'" . '~^_*+#-]'
    let section = '\v^%(%([=-]{3,}\s+[=-]{3,})\n)@<!.+\n(' . delims . ')\1*$'
    for n in range(a:cnt)
        call search(section, a:back ? 'bW' : 'W')
    endfor
endfunc
