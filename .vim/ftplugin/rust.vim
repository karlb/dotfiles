let g:ale_fix_on_save = 1

" Reload buffer after ALE fixing completes
augroup ale_fix_reload
  autocmd!
  autocmd User ALEFixPost :checktime
augroup END

let g:ale_completion_enabled = 1
