local buffer = -1
local prev_buf = -1
local prev_win = -1
local dir_path = vim.fn.expand('%:p:h')


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
  vim.notify("Job " .. job_id .. " exited with code " .. code .. " and event " .. event)
  vim.pretty_print({ job_id, code, event })
  local contents = get_file_contents(vim.g.patra_temp_file)
  vim.notify("Contents of " .. vim.g.patra_temp_file .. ": " .. contents)
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

local function open_patra()
  prev_buf = vim.api.nvim_get_current_buf()
  prev_win = vim.api.nvim_get_current_win()
  dir_path = vim.fn.expand('%:p:h')
  vim.notify("dir_path: " .. dir_path)
  vim.cmd("enew")
  vim.g.patra_temp_file = vim.fn.tempname()

  local cmd = 'patra ' .. dir_path .. ' --selection-path ' .. vim.g.patra_temp_file

  exec_patra_cmd(cmd)
end

return {
    open_patra = open_patra,
}
