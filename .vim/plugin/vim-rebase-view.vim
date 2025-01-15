call minpac#add('piersy/vim-rebase-view')

augroup rebase_keymaps
	autocmd!
	autocmd filetype gitrebase call s:ConfigureRebaseKeymaps()
augroup END

function! s:ConfigureRebaseKeymaps()
	" git show --stat xxxx - where xxxx is the commit on the current line
	nnoremap <silent> <buffer> <leader>e :call rebaseview#DisplayCommit('--stat')<CR>

	" git show xxxx - where xxxx is the commit on the current line
	nnoremap <silent> <buffer> <leader>d :call rebaseview#DisplayCommit('')<CR>

	" show a log of the range of commits in this rebase, commits are displayed
	" in reverse order so that they appear in the same order as those in the
	" rebase.
	nnoremap <silent> <buffer> <leader>l :call rebaseview#DisplayLog('--stat')<CR>
endfunction
