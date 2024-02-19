if exists("current_compiler")
    finish
endif

let current_compiler = "rst2pdf"
let s:keepcpo= &cpo
set cpo&vim

let s:input = shellescape(expand("%:p"))
let s:output = shellescape(expand("%:p:r").".pdf")

let &l:makeprg = printf('rst2pdf %s -o %s',
      \ s:input,
      \ s:output
      \ )

let &cpo = s:keepcpo
unlet s:keepcpo
