local buffer = -1
local prev_buf = -1
local prev_win = -1
local dir_path = vim.fn.expand('%:p:h')
vim.g.patra_config = '/home/bmax/.config/patra/test.toml'

local function write_to_file(file_path, contents)
  local file = io.open(file_path, 'w')
  if file then
    file:write(contents)
    file:close()
  else
    -- vim.print("Error: Could not open file " .. file_path)
  end
end

local function get_file_contents(file_path)
  local file = io.open(file_path)
  local contents = "nothing"
  if file then
    contents = file:read("*all")
    io.close(file)
  end
  return contents
end

local function on_exit(job_id, code, event)
  vim.wo.rnu = true
  vim.wo.nu = true
  -- vim.print({ job_id, code, event })
  local contents = get_file_contents(vim.g.patra_temp_file)
  -- vim.api.nvim_buf_delete(buffer, {})
  buffer = -1
  if code == 0 then
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, prev_buf)
  else
    if contents ~= "nothing" then
      vim.cmd('drop ' .. contents)
    end
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_win_set_buf(prev_win, buf)
    vim.fn.win_gotoid(prev_win)
  end
end

local function exec_patra_cmd(cmd)
  vim.fn.termopen(cmd, { on_exit = on_exit })
  buffer = vim.api.nvim_get_current_buf()
  vim.cmd("startinsert")
end

local function get_hl(hl_name, fg_bg)
  local color = vim.api.nvim_get_hl_by_name(hl_name, true)[fg_bg]
  local bit = require("bit")
  if color == nil then
    -- vim.print({
    --     "NIL",
    --     hl_name,
    --     fg_bg,
    --     color
    -- })
    return ""
  end
  local r = bit.band(bit.rshift(color, 16), 0xff)
  local g = bit.band(bit.rshift(color, 8), 0xff)
  local b = bit.band(color, 0xff)

  local cursor_color = string.format("#%02x%02x%02x", r, g, b)
  return cursor_color
end

local function open_patra()
  prev_buf = vim.api.nvim_get_current_buf()
  prev_win = vim.api.nvim_get_current_win()
  dir_path = vim.fn.expand('%:p:h')
  vim.cmd("enew")
  vim.g.patra_temp_file = vim.fn.tempname()

  local cmd = 'patra ' .. dir_path .. ' --selection-path ' .. vim.g.patra_temp_file
  if vim.g.patra_config ~= nil then
    cmd = cmd .. ' --config ' .. vim.g.patra_config
  end
  vim.wo.rnu = false
  vim.wo.nu = false

  exec_patra_cmd(cmd)
end

local function theme_update_content(theme, key, value)
  if theme == "" then
    theme = '[theme]\n'
    theme = theme .. key .. '=' .. "'" .. value .. "'\n"
  else
    theme = theme .. key .. '=' .. "'" .. value .. "'\n"
  end
  return theme
end

local function setup_theme()
  -- local dir          = get_hl("Number", "foreground")
  local dir          = get_hl("Directory", "foreground")
  local normal       = get_hl("Normal", "foreground")
  -- local dir          = get_hl("Directory", "foreground")
  local cursor_color = get_hl("CursorLine", "background")
  -- TODO: get and pass Directory color


  -- vim.print({ corsor = cursor_color, normal = normal, dir = dir })
  local theme = ''

  if normal ~= "" then
    theme = theme_update_content(theme, 'file_fg', normal)
  end
  if cursor_color ~= "" then
    theme = theme_update_content(theme, 'file_focus_bg', cursor_color)
  end
  if dir ~= "" then
    theme = theme_update_content(theme, 'dir_fg', dir)
  end
  vim.g.patra_config = vim.fn.tempname()
  local file = vim.g.patra_config
  -- vim.print({ the = 'the theme', file, theme })
  write_to_file(file, theme)
end
local function setup()
  setup_theme()
end


return {
    open_patra = open_patra,
    setup_theme = setup_theme,
    setup = setup,
}
