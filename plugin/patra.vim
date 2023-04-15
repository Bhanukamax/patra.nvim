
command! Patra :lua require"patra".open_patra()
command! PatraTheme :lua require"patra".setup_theme()
" autocmd BufEnter <filetype=patra> :startinsert 
augroup Patra
  " Redo color scheme update if the theme change
  autocmd ColorScheme * PatraTheme
  " To make sure that patra alwaly go into insert mode even if you switched to
  " another split and comeback
  autocmd BufEnter,WinEnter * if &ft == 'patra' | startinsert | endif
augroup END


