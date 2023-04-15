local buffer = vim.api.nvim_get_current_buf()

vim.keymap.set('t', '<C-w>', "<C-\\><C-N><C-w>", { buffer = buffer })
vim.keymap.set('t', 'ZZ', "<C-\\><C-N>ZZ", { buffer = buffer })
vim.keymap.set('t', 'ZQ', "<C-\\><C-N>ZQ", { buffer = buffer })
