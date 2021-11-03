if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let s:undo_opts = "setl flp< com<"

let s:undo_maps = "| execute 'nunmap <buffer> ]]'"
            \. "| execute 'nunmap <buffer> [['"
            \. "| execute 'ounmap <buffer> ]]'"
            \. "| execute 'ounmap <buffer> [['"
            \. "| execute 'xunmap <buffer> ]]'"
            \. "| execute 'xunmap <buffer> [['"

if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= "|" . s:undo_opts . s:undo_maps
else
    let b:undo_ftplugin = s:undo_opts . s:undo_maps
endif

compiler rst2html

setlocal comments=

let g:rst_listitem = '^\s*\%('
let g:rst_listitem .= '\%([-+*]\)'
let g:rst_listitem .= '\|'
let g:rst_listitem .= '\%(\d\+[.)]\)'
let g:rst_listitem .= '\|'
let g:rst_listitem .= '\%((\d\+)\)'
let g:rst_listitem .= '\|'
let g:rst_listitem .= '\%(\%(\a\|#\)[.)]\)'
let g:rst_listitem .= '\|'
let g:rst_listitem .= '\%((\%(\a\|#\))\)'
let g:rst_listitem .= '\|'
let g:rst_listitem .= '\%(|\)'
let g:rst_listitem .= '\)'

let &l:formatlistpat = g:rst_listitem . '\s\+'

nnoremap <silent><buffer> ]] :<c-u>call <sid>section(0, v:count1)<CR>
nnoremap <silent><buffer> [[ :<c-u>call <sid>section(1, v:count1)<CR>
xmap     <buffer><expr>   ]] "\<esc>".v:count1.']]m>gv'
xmap     <buffer><expr>   [[ "\<esc>".v:count1.'[[m>gv'
onoremap <buffer>         ]] :<c-u>call <sid>section(0, v:count1)<CR>
onoremap <buffer>         [[ :<c-u>call <sid>section(1, v:count1)<CR>

"" Next/Previous section mappings
func! s:section(back, cnt)
    let delims = '[=`:."' . "'" . '~^_*+#-]'
    let section = '\v^%(%([=-]{3,}\s+[=-]{3,})\n)@<!.+\n(' . delims . ')\1*$'
    normal! m`
    for n in range(a:cnt)
        call search(section, a:back ? 'bW' : 'W')
    endfor
endfunc
