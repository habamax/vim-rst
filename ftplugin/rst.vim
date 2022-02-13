if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let s:undo_opts = "setl flp< com< cms<"

let s:undo_maps = "| execute 'nunmap <buffer> ]]'"
      \. "| execute 'nunmap <buffer> [['"
      \. "| execute 'ounmap <buffer> ]]'"
      \. "| execute 'ounmap <buffer> [['"
      \. "| execute 'xunmap <buffer> ]]'"
      \. "| execute 'xunmap <buffer> [['"
      \. "| execute 'nunmap <buffer> gx'"

if get(g:, "rst_mappings", 1)
    let s:undo_maps = "| execute 'ounmap <buffer> ie'"
          \. "| execute 'ounmap <buffer> ae'"
          \. "| execute 'xunmap <buffer> ie'"
          \. "| execute 'xunmap <buffer> ae'"
          \. "| execute 'ounmap <buffer> iP'"
          \. "| execute 'ounmap <buffer> aP'"
          \. "| execute 'xunmap <buffer> iP'"
          \. "| execute 'xunmap <buffer> aP'"
endif

if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= "|" . s:undo_opts . s:undo_maps
else
    let b:undo_ftplugin = s:undo_opts . s:undo_maps
endif

compiler rst2html

setlocal commentstring=..\ %s
setlocal comments=

let g:rst_listitem = '\s*\%('
let g:rst_listitem .= '\%([-+*]\)'
let g:rst_listitem .= '\|'
let g:rst_listitem .= '\%(\d\+[.)]\)'
let g:rst_listitem .= '\|'
let g:rst_listitem .= '\%((\d\+)\)'
let g:rst_listitem .= '\|'
let g:rst_listitem .= '\%(\%(\a\|#\)[.)]\)'
let g:rst_listitem .= '\|'
let g:rst_listitem .= '\%((\%(\a\|#\))\)'
let g:rst_listitem .= '\)'

let &l:formatlistpat = '^\s*\%(' . g:rst_listitem . '\|\%(|\)\)\s\+'


if get(g:, "rst_mappings", 1)
    onoremap <silent><buffer>ie :<C-u>call rst#environment_tobj(1)<CR>
    onoremap <silent><buffer>ae :<C-u>call rst#environment_tobj(0)<CR>
    xnoremap <silent><buffer>ie :<C-u>call rst#environment_tobj(1)<CR>
    xnoremap <silent><buffer>ae :<C-u>call rst#environment_tobj(0)<CR>
    onoremap <silent><buffer>iP :<C-u>call rst#section_tobj(1)<CR>
    onoremap <silent><buffer>aP :<C-u>call rst#section_tobj(0)<CR>
    xnoremap <silent><buffer>iP :<C-u>call rst#section_tobj(1)<CR>
    xnoremap <silent><buffer>aP :<C-u>call rst#section_tobj(0)<CR>
    nnoremap <silent><buffer>gx :<C-u>call rst#gx()<CR>
endif

nnoremap <silent><buffer> ]] :<c-u>call rst#section(0, v:count1)<CR>
nnoremap <silent><buffer> [[ :<c-u>call rst#section(1, v:count1)<CR>
xmap     <buffer><expr>   ]] "\<esc>".v:count1.']]m>gv'
xmap     <buffer><expr>   [[ "\<esc>".v:count1.'[[m>gv'
onoremap <buffer>         ]] :<c-u>call rst#section(0, v:count1)<CR>
onoremap <buffer>         [[ :<c-u>call rst#section(1, v:count1)<CR>
