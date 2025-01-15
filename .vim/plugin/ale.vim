" Display errors in a nicer way using nvim's diagnostics API
let g:ale_use_neovim_diagnostics_api = 1
" Completion
let g:ale_completion_enabled = 1
" Show linter name in message
let g:ale_echo_msg_format = '%s [%linter%]'
" Open location list on error
let g:ale_open_list = 0

" Mappings in the style of unimpaired-next
nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]w <Plug>(ale_next)
nmap <silent> ]W <Plug>(ale_last)

" Go to definition
function! GoToDefinition()
  if len(filter(lsp#get_allowed_servers(), 'lsp#is_server_running(v:val)')) > 0
    " Use LSP
    execute "normal \<Plug>(ale_go_to_definition)"
  else
    " Fallback to default behavior
    normal! gd
  endif
endfunction
nmap <silent> gd :call GoToDefinition()<CR>
" nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> gD <Plug>(ale_go_to_implementation)
nmap <silent> gh <Plug>(ale_go_to_type_definition)
nmap <silent> gr <Plug>(ale_find_references)

" Default fixers
let g:ale_fixers = {}
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_fixers['md'] = ['remove_trailing_lines']  " trailing whitespace is meaningful
let g:ale_fixers['go'] = ['gofmt', 'goimports']
