
command! Patra :lua require"patra".open_patra()
command! PatraTheme :lua require"patra".setup_theme()
autocmd ColorScheme * PatraTheme
