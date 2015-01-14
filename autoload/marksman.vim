" Vim library for better Marks Management
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" Version:	0.1
" Description:	1. Jumps to global marks also jump to last cursor position
" 		2. Jumps to deleted marks jump close to last known position
" Last Change:	2015-01-14
" License:	Vim License (see :help license)
" Location:	autoload/marksman.vim
" Website:	https://github.com/dahu/marksman
"
" See marksman.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help marksman

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" load guard
"if exists("g:loaded_lib_marksman")
"      \ || v:version < 700
"      \ || &compatible
"  let &cpo = s:save_cpo
"  finish
"endif
"let g:loaded_lib_marksman = 1

" Vim Script Information Function: {{{1
" Use this function to return information about your script.
function! marksman#info()
  let info = {}
  let info.name = 'marksman'
  let info.version = 1.0
  let info.description = 'Better Marks Management'
  let info.dependencies = [{'name': 'vimple', 'version': 0.9}]
  return info
endfunction

" Library Interface: {{{1

function! marksman#update()
  if !has_key(b:, 'marksman')
    let b:marksman = {}
  endif
  call map(g:vimple#ma.update().local_marks().to_l(), 'extend(b:marksman, {v:val.mark : v:val})')
endfunction

function! marksman#set()
  let jump_mark=nr2char(getchar())
  exe "norm! m" . jump_mark
  call marksman#update()
endfunction

function! marksman#jump(jump_type)
  let jump_mark=nr2char(getchar())

  let marks = {}
  call map(g:vimple#ma.update().local_marks().to_l(), 'extend(marks, {v:val.mark : v:val})')

  if jump_mark =~# '[A-Z]'
    return ":norm! '" . jump_mark . "`\""
  elseif jump_mark =~# '[a-z]'
    if has_key(marks, jump_mark)
      return a:jump_type . jump_mark
    elseif has_key(b:marksman, jump_mark)
      return ":norm! " . b:marksman[jump_mark].line . "G" . b:marksman[jump_mark].col . "|\<cr>"
    else
      " This will cause "E20: Mark not set"
      return a:jump_type . jump_mark
    endif
  else
    return a:jump_type . jump_mark
  endif
endfunction

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" Template From: https://github.com/dahu/Area-41/
" vim: set sw=2 sts=2 et fdm=marker:
