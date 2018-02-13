" Maintainer:	Coredumb
" Version:      0.1
" Last Change:	Sunday, 06.11
" Credits:      This is a modification of BusyBee.vim - http://vimcolorschemetest.googlecode.com/svn/colors/BusyBee.vim

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "busybee"

" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine    ctermbg=234
  hi CursorColumn  ctermbg=234
  hi MatchParen    ctermfg=115 ctermbg=237 cterm=bold
  hi Pmenu 		   ctermfg=255 ctermbg=238
  hi PmenuSel 	   ctermfg=0 ctermbg=148
endif

" General colors
hi Cursor 		   ctermbg=241
hi Normal 		   ctermfg=252 ctermbg=235
hi NonText 		   ctermfg=244 ctermbg=235
hi LineNr 		   ctermfg=241 ctermbg=236
hi StatusLine 	   ctermfg=253 ctermbg=238
hi StatusLineNC    ctermfg=246 ctermbg=238
hi VertSplit 	   ctermfg=238 ctermbg=238
hi Folded 		   ctermbg=4   ctermfg=248
hi Title		   ctermfg=254 cterm=bold
hi Visual		   ctermfg=254 ctermbg=4
hi SpecialKey	   ctermfg=244 ctermbg=236

" Syntax highlighting
hi Comment 		   ctermfg=241
hi Todo 		   ctermfg=245
hi Boolean         ctermfg=148
hi String 		   ctermfg=148
hi Identifier 	   ctermfg=148
hi Function 	   ctermfg=211
hi Type 		   ctermfg=104
hi Statement 	   ctermfg=104
hi Keyword		   ctermfg=208
hi Constant 	   ctermfg=103
hi Number		   ctermfg=208
hi Special		   ctermfg=208
hi PreProc 		   ctermfg=211
hi Todo            ctermfg=211

" Code-specific colors
" Python
hi pythonException      ctermfg=200
hi pythonOperator       ctermfg=104
hi pythonFunction       ctermfg=211
hi pythonExClass        ctermfg=200

" Perl
hi perlVarPlain         ctermfg=117
hi perlVarPlain2        ctermfg=117
