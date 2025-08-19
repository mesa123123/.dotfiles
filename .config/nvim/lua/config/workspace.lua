local M = {}

M.load = function()
  local workspace_config_file = vim.fn.getcwd() .. "/.nvim.lua"
  local stat = vim.loop.fs_stat(workspace_config_file)

  if stat and stat.type == "file" then
    -- Use loadfile to compile the chunk, then call it to get the return value.
    -- This is the correct way to handle a file that returns a value.
    local chunk, err = loadfile(workspace_config_file)

    if not chunk then
      vim.notify("Error in workspace config syntax: " .. err, vim.log.levels.ERROR)
      return nil
    end

    local ok, settings = pcall(chunk)

    if ok and settings then
      vim.notify("Loaded workspace configuration from: " .. workspace_config_file, vim.log.levels.INFO)
      -- You now have the `M` table from the file in the `settings` variable.
      -- Here, you would apply those settings.
      return settings
    else
      vim.notify("Error executing workspace config: " .. tostring(settings), vim.log.levels.ERROR)
      return nil
    end
  end

  return nil -- Return nil if no file is found
end

return M
