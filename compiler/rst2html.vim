if exists("current_compiler")
    finish
endif

let current_compiler = "rst2html"
let s:keepcpo= &cpo
set cpo&vim

let s:input = shellescape(expand("%:p"))
let s:output = shellescape(expand("%:p:r").".html")

let &l:makeprg = printf("%s %s %s %s",
      \ get(g:, "rst2html_prg", "rst2html5.py"),
      \ get(b:, "rst2html_opts",
      \         get(g:, "rst2html_opts",
      \                 "--input-encoding=utf8"
      \               . " --stylesheet-path=minimal.css,responsive.css")),
      \ s:input,
      \ s:output
      \ )

let &cpo = s:keepcpo
unlet s:keepcpo
