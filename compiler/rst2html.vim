if exists("current_compiler")
    finish
endif

let current_compiler = "rst2html"
let s:keepcpo= &cpo
set cpo&vim

let s:input = $'"{expand("%:p")}"'
let s:output = $'"{expand("%:p:r")}.html"'

let &l:makeprg = printf("%s %s %s %s",
      \ get(g:, "rst2html_prg", "rst2html5"),
      \ get(b:, "rst2html_opts",
      \         get(g:, "rst2html_opts",
      \                 "--input-encoding=utf8"
      \               . " --stylesheet-path=minimal.css,responsive.css")),
      \ s:input,
      \ s:output
      \ )

let &cpo = s:keepcpo
unlet s:keepcpo
