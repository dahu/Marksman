" Vim global plugin for better Marks Management
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" Version:	0.2
" Description:	1. Jumps to global marks also jump to last cursor position
" 		2. Jumps to deleted marks jump close to last known position
" Last Change:	2015-01-14
" License:	Vim License (see :help license)
" Location:	plugin/Marksman.vim
" Website:	https://github.com/dahu/Marksman
"
" See Marksman.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help Marksman

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" load guard
if exists("g:loaded_Marksman")
      \ || v:version < 700
      \ || &compatible
  let &cpo = s:save_cpo
  finish
endif
let g:loaded_Marksman = 1

" Maps: {{{1
nnoremap <expr>   '       marksman#jump("'")
nnoremap <expr>   `       marksman#jump("`")
nnoremap <silent> m :call marksman#set()<cr>

augroup Marksman
  au!
  au BufEnter * if !has_key(b:, 'marksman') | call marksman#update() | endif
augroup END

" Teardown: {{{1
" reset &cpo back to users setting
let &cpo = s:save_cpo

" Template From: https://github.com/dahu/Area-41/
" vim: set sw=2 sts=2 et fdm=marker:
