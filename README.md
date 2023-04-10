# Patra nvim

neovim wrapper for the [Patra TUI](https://github.com/Bhanukamax/patra) file manager

## Caution!
this is still at very early development, not recommended for regular use

## installation and config with lazy nvim
```lua
{
  'Bhanukamax/patra.nvim',
    config = function()
      vim.keymap.set('n', '<leader>o', ":Patra<CR>")
    end
}
```
