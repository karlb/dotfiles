" Vim compiler file
" Compiler:	pytb
" Maintainer: 	Karl Bartel <karl@karl.berlin>

if exists("current_compiler")
  finish
endif
let current_compiler = "pytb"

CompilerSet makeprg=python3

" Vim errorformat cheatsheet:
" %-G		ignore this message
" %+G		general message
" %.%#          .*

CompilerSet errorformat=%+G\ \ File\ \"%f\"\\,\ line\ %l\\,\ in\ %m  " files position lines
CompilerSet errorformat+=%-G\ \ \ \ %.%#  " traceback rows including code -> ignore
