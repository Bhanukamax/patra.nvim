local buffer = -1

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
  vim.api.nvim_buf_delete(buffer, {})
  buffer = -1
  if contents ~= "nothing" then
    vim.cmd('edit ' .. contents)
  end
end

local function exec_patra_cmd(cmd)
  vim.fn.termopen(cmd, { on_exit = on_exit })
  buffer = vim.api.nvim_get_current_buf()
  vim.cmd("startinsert")
end

local function open_patra()
  vim.cmd("enew")
  vim.g.patra_temp_file = vim.fn.tempname()

  local cmd = 'patra' .. ' --selection-path ' .. vim.g.patra_temp_file

  exec_patra_cmd(cmd)
end

return {
  open_patra = open_patra,
}
