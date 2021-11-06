" Vim reStructuredText syntax file
" Language: reStructuredText document format
" Maintainer: Maxim Kim <habamax@gmail.com>
" Description: Based on https://github.com/marshallward/vim-restructuredtext

if exists("b:current_syntax")
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

syn cluster rstInlineMarkup contains=rstEmphasis,rstStrongEmphasis,
      \ rstInterpretedText,rstInlineLiteral,rstSubstitutionReference,
      \ rstInlineInternalTarget,rstFootnoteReference,rstHyperlinkReference,
      \ rstStandaloneHyperlink,rstFieldName,rstListItem

syn match rstLineBlock /^\s*|/ contained

if exists("g:rst_listitem")
    execute 'syn match rstListItem /' . g:rst_listitem . '\ze\s\+/ contains=rstLineBlock'
endif

syn region rstLiteralBlock matchgroup=rstDelimiter
      \ start='\(^\z(\s*\).*\)\@<=::\n\s*\n'
      \ skip='^\s*$'
      \ end='^\(\z1\s\+\)\@!'
      \ contains=@NoSpell

syn region rstLiteralBlock matchgroup=rstDelimiter
      \ start='\(^\z(\s*\)\z\([-*+]\)\z\(\s\)\z(\s*\).*\)\@<=::\n\s*\n'
      \ skip='^\s*$'
      \ end='^\(\z1\z3\z3\z4\s\+\)\@!'
      \ contains=@NoSpell

syn region rstLiteralBlock matchgroup=rstDelimiter
      \ start='\(^\z(\s*\)\z\([#[:alnum:]][.)]\)\z\(\s\)\z(\s*\).*\)\@<=::\n\s*\n'
      \ skip='^\s*$'
      \ end='^\(\z1\z3\z3\z3\z4\s\+\)\@!'
      \ contains=@NoSpell

syn region rstLiteralBlock matchgroup=rstDelimiter
      \ start='\(^\z(\s*\)\z\(([#[:alnum:]])\)\z\(\s\)\z(\s*\).*\)\@<=::\n\s*\n'
      \ start='\(^\z(\s*\)\z\(\d\d[.)]\)\z\(\s\)\z(\s*\).*\)\@<=::\n\s*\n'
      \ skip='^\s*$'
      \ end='^\(\z1\z3\z3\z3\z3\z4\s\+\)\@!'
      \ contains=@NoSpell

syn region rstQuotedLiteralBlock matchgroup=rstDelimiter
      \ start="::\_s*\n\ze\z([!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]\)"
      \ end='^\z1\@!' contains=@NoSpell

syn region rstDoctestBlock
      \ start='^\z(\s*\)\ze>>>\s'
      \ skip='^\ze\z1\s*\S'
      \ end='^\ze\s*\S'
      \ end='^\s*$'
      \ contains=rstDoctestBlockPrompt
      \ keepend
syn match rstDoctestBlockPrompt contained '^\s*>>>\s\+'

syn region rstFieldName start=+^\s*:\ze\S+ skip=+\\:+ end=+\S\zs:\ze\(\s\|$\)+ oneline

syn cluster rstDirectives contains=rstFootnote,rstCitation,
      \ rstComment,rstExDirective,rstCodeBlock,
      \ rstHyperLinkTarget,rstLiteralBlock,rstQuotedLiteralBlock,
      \ @rstTables

syn region rstComment
      \ start='^\z(\s*\)\.\.\s*$'
      \ start='^\z(\s*\)\.\.\_s\?\s*\S'
      \ skip='^\ze\z1\s\+\S'
      \ end='^\ze\s*\S'

syn region rstExDirective
      \ matchgroup=rstDirective
      \ start='^\z(\s*\)\.\.\s\+.\{-}::\ze\%([^:]\|$\)'
      \ skip='^\ze\z1\s\+\S'
      \ end='^\ze\s*\S'
      \ contains=@rstDirectives,@rstInlineMarkup
      \ keepend
      \ transparent

syn region rstHyperlinkTarget matchgroup=rstDirective
      \ start='^\z(\s*\)\.\.\s\+_\%(_\|[^:\\]*\%(\\.[^:\\]*\)*\):\(\s\|$\)'
      \ skip='^\ze\z1\s\+\S'
      \ matchgroup=NONE
      \ end='^\ze\s*\S'
      \ contains=@rstDirectives,rstStandaloneHyperlink
      \ keepend

syn region rstHyperlinkTarget matchgroup=rstDirective
      \ start='^\z(\s*\)__\s*$'
      \ start='^\z(\s*\)__\_s'
      \ skip='^\ze\z1\s\+\S'
      \ matchgroup=NONE
      \ end='^\ze\s*\S'
      \ contains=@rstDirectives,rstStandaloneHyperlink
      \ keepend

syn region rstFootnote
      \ matchgroup=rstDirective
      \ start='^\z(\s*\)\.\.\s\+\[\%(\d\+\|#\%([[:alnum:]]\%([-_.:+]\?[[:alnum:]]\+\)*\)\=\|\*\)\]\_s'
      \ skip='^\ze\z1\s\+\S'
      \ matchgroup=NONE
      \ end='^\ze\s*\S'
      \ keepend
      \ contains=@rstDirectives,@rstInlineMarkup

syn region rstCitation matchgroup=rstDirective
      \ start='^\z(\s*\)\.\.\s\+\[[[:alnum:]]\%([-_.:+]\?[[:alnum:]]\+\)*\]\_s'
      \ skip='^\ze\z1\s\+\S'
      \ matchgroup=NONE
      \ end='^\ze\s*\S'
      \ keepend
      \ contains=@rstDirectives,@rstInlineMarkup

syn region rstCodeBlock
      \ matchgroup=rstDirective
      \ start='^\z(\s*\)\.\.\s\+\c\%(sourcecode\|code\%(-block\)\=\)::.*'
      \ skip='^\ze\z1\s\+\S'
      \ matchgroup=NONE
      \ end='^\ze\s*\S'
      \ keepend

for s:filetype in keys(get(g:, "rst_syntax_code_list", {}))
    unlet! b:current_syntax
    " guard against setting 'isk' option which might cause problems (issue #108)
    let prior_isk = &l:iskeyword
    let s:alias_pattern = ''
          \. '\%('
          \. join(g:rst_syntax_code_list[s:filetype], '\|')
          \. '\)'

    exe 'syn include @rstSyntax'.s:filetype.' syntax/'.s:filetype.'.vim'
    exe 'syn region rstCodeBlock'.s:filetype
          \. ' matchgroup=rstDirective'
          \. ' start=#^\z(\s*\)\.\.\s\+\c\%(sourcecode\|code\%(-block\)\=\)::\s\+'.s:alias_pattern.'#'
          \. ' skip=#^\ze\z1\s\+\S#'
          \. ' matchgroup=NONE'
          \. ' end=#^\ze\s*\S#'
          \. ' keepend'
          \. ' contains=@NoSpell,@rstSyntax'.s:filetype
    exe 'syn cluster rstDirectives add=rstCodeBlock'.s:filetype

    " reset 'isk' setting, if it has been changed
    if &l:iskeyword !=# prior_isk
        let &l:iskeyword = prior_isk
    endif
    unlet! prior_isk
endfor


" Inline markup recognition rules
" https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#inline-markup
syn region rstStrongEmphasis matchgroup=rstDelimiter
      \ start=+\%(^\|[[:space:]-:/]\)\zs\*\*\ze[^[:space:]]+
      \ skip=+\\\*+
      \ end=+\S\zs\*\*\ze\($\|[[:space:]-.,:;!?"'/\\>)\]}]\)+
      \ concealends

syn region rstEmphasis matchgroup=rstDelimiter
      \ start=+\%(^\|[[:space:]-:/]\)\zs\*\ze[^*[:space:]]+
      \ skip=+\\\*+
      \ end=+\S\zs\*\ze\($\|[[:space:]-.,:;!?"'/\\>)\]}]\)+
      \ concealends

syn region rstInlineLiteral matchgroup=rstDelimiter
      \ start=+\(^\|[[:space:]-:/]\)\zs``\ze\S+
      \ end=+\S\zs``\ze\($\|[[:space:]-.,:;!?"'/\\>)\]}]\)+
      \ concealends

syn region rstInlineInternalTarget matchgroup=rstDelimiter
      \ start=+\(^\|[[:space:]-:/]\)\zs_`\ze[^`[:space:]]+
      \ skip=+\\`+
      \ end=+\S\zs`\ze\($\|[[:space:]-.,:;!?"'/\\>)\]}]\)+
      \ concealends

syn region rstInterpretedText matchgroup=rstDelimiter contains=rstStandaloneHyperlink
      \ start=+\(^\|[[:space:]-:/]\)\zs\%(:[[:alnum:]]\%([-_.:+]\?[[:alnum:]]\+\)*:\)\?`\ze[^`[:space:]]+
      \ skip=+\\`+
      \ end=+\S\zs`_\{0,2}\ze\($\|[[:space:].,:;!?"'/\\>)\]}]\)+
      \ end=+\S\zs`\%(:[[:alnum:]]\%([-_.:+]\?[[:alnum:]]\+\)*:\)\?\ze\($\|[[:space:]-.,:;!?"'/\\>)\]}]\)+
      \ concealends

syn region rstSubstitutionReference matchgroup=rstDelimiter
      \ start=+\%(^\|[[:space:]-:/]\)\zs|\ze[^|[:space:]]+
      \ skip=+\\|+
      \ end=+\S\zs|_\{0,2}\ze\($\|[[:space:]-.,:;!?"'/\\>)\]}]\)+
      \ concealends

for s:ch in [['(', ')'], ['{', '}'], ['<', '>'], ['\[', '\]'], ['"', '"'], ["'", "'"]]
    execute 'syn region rstStrongEmphasis matchgroup=rstDelimiter' .
          \ ' start=+'.s:ch[0].'\zs\*\*\ze[^[:space:]'.s:ch[1].']+' .
          \ ' skip=+\\\*+' .
          \ ' end=+\S\zs\*\*\ze\($\|[[:space:]-.,:;!?"'."'".'/\\>)\]}]\)+' .
          \ ' concealends'
    execute 'syn region rstEmphasis matchgroup=rstDelimiter' .
          \ ' start=+'.s:ch[0].'\zs\*\ze[^*[:space:]'.s:ch[1].']+' .
          \ ' skip=+\\\*+' .
          \ ' end=+\S\zs\*\ze\($\|[[:space:]-.,:;!?"'."'".'/\\>)\]}]\)+' .
          \ ' concealends'
    execute 'syn region rstInlineLiteral matchgroup=rstDelimiter' .
          \ ' start=+'.s:ch[0].'\zs``\ze[^[:space:]'.s:ch[1].']+' .
          \ ' end=+\S\zs``\ze\($\|[[:space:]-.,:;!?"'."'".'/\\>)\]}]\)+' .
          \ ' concealends'
    execute 'syn region rstInlineInternalTarget matchgroup=rstDelimiter' .
          \ ' start=+'.s:ch[0].'\zs_`\ze[^`[:space:]'.s:ch[1].']+' .
          \ ' skip=+\\`+' .
          \ ' end=+\S\zs`\ze\($\|[[:space:]-.,:;!?"'."'".'/\\>)\]}]\)+' .
          \ ' concealends'
    execute 'syn region rstInterpretedText matchgroup=rstDelimiter contains=rstStandaloneHyperlink' .
          \ ' start=+'.s:ch[0].'\zs`\ze[^`[:space:]'.s:ch[1].']+' .
          \ ' skip=+\\`+' .
          \ ' end=+\S\zs`_\{0,2}\ze\($\|[[:space:]-.,:;!?"'."'".'/\\>)\]}]\)+' .
          \ ' concealends'
    execute 'syn region rstSubstitutionReference matchgroup=rstDelimiter' .
          \ ' start=+'.s:ch[0].'\zs|\ze[^|[:space:]'.s:ch[1].']+' .
          \ ' skip=+\\|+' .
          \ ' end=+\S\zs|_\{0,2}\ze\($\|[[:space:]-.,:;!?"'."'".'/\\>)\]}]\)+' .
          \ ' concealends'
endfor

syn match rstFootnoteReference contains=@NoSpell
      \ +\%(\s\|^\)\[\%(\d\+\|#\%([[:alnum:]]\%([-_.:+]\?[[:alnum:]]\+\)*\)\=\|\*\)\]_+

syn match rstCitationReference contains=@NoSpell
      \ +\%(\s\|^\)\[[[:alnum:]]\%([-_.:+]\?[[:alnum:]]\+\)*\]_\ze\%($\|\s\|[''")\]}>/:.,;!?\\-]\)+

syn match rstHyperlinkReference
      \ /\<[[:alnum:]]\%([-_.:+]\?[[:alnum:]]\+\)*__\=\ze\%($\|\s\|[''")\]}>/:.,;!?\\-]\)/

syn match rstStandaloneHyperlink contains=@NoSpell
      \ "\<\%(\%(\%(https\=\|file\|ftp\|gopher\)://\|\%(mailto\|news\):\)[^[:space:]'\"<>]\+\|www[[:alnum:]_-]*\.[[:alnum:]_-]\+\.[^[:space:]'\"<>]\+\)[[:alnum:]/]"

syn cluster rstTables contains=rstTable,rstSimpleTable
syn region rstTable transparent start='^\n\s*+[-=+]\+' end='^$'
      \ contains=rstTableLines,@rstInlineMarkup
syn match rstTableLines contained display '|\|+\%(=\+\|-\+\)\='
syn match rstSimpleTable
      \ '^\s*\%(===\+\)\%(\s*===\+\)\+\s*$'
syn match rstSimpleTable
      \ '^\s*\%(---\+\)\%(\s*---\+\)\+\s*$'

syn match rstSectionDelimiter contained "\v^([=`:.'"~^_*+#-])\1*\s*$"
syn match rstSection "\v^%(%([=-]{3,}\s+[=-]{3,})\n)@<!\S.*\n([=`:.'"~^_*+#-])\1*$"
      \ contains=rstSectionDelimiter,@Spell
syn match rstSection "\v^%(([=`:.'"~^_*+#-])\1*\n).+\n([=`:.'"~^_*+#-])\2*$"
      \ contains=rstSectionDelimiter,@Spell

syn match rstTransition /^\n[=`:.'"~^_*+#-]\{4,}\s*\n$/



" Enable top level spell checking
syntax spell toplevel

if !exists('g:rst_minlines')
  let g:rst_minlines = 50
endif
execute 'syn sync minlines=' . g:rst_minlines . ' linebreaks=2'

hi def link rstComment                      Comment
hi def link rstSection                      Title
hi def link rstSectionDelimiter             Type
hi def link rstDelimiter                    Delimiter
hi def link rstTransition                   rstDelimiter
hi def link rstLiteralBlock                 String
hi def link rstQuotedLiteralBlock           String
hi def link rstDoctestBlock                 PreProc
hi def link rstTableLines                   rstDelimiter
hi def link rstSimpleTable                  rstTableLines
hi def link rstDirective                    Keyword
hi def link rstExDirective                  rstDirective
hi def link rstFieldName                    Constant
hi def link rstLineBlock                    rstDelimiter
hi def link rstListItem                     Constant
hi def link rstInterpretedText              Identifier
hi def link rstInlineLiteral                String
hi def link rstSubstitutionReference        PreProc
hi def link rstInlineInternalTarget         Identifier
hi def link rstFootnoteReference            Identifier
hi def link rstCitationReference            Identifier
hi def link rstHyperLinkReference           Identifier
hi def link rstStandaloneHyperlink          Underlined
hi def link rstCodeBlock                    String
hi def link rstDoctestBlockPrompt           rstDelimiter
hi def rstEmphasis term=italic cterm=italic gui=italic
hi def rstStrongEmphasis term=bold cterm=bold gui=bold

let b:current_syntax = "rst"

let &cpo = s:cpo_save
unlet s:cpo_save
