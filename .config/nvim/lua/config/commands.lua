----------------------
-- ##############  --
-- #  Commands  #  --
-- ##############  --
----------------------

---------------------------------
-- Module Table
---------------------------------

local M = {}

---------------------------------

--------------------------------
-- Setup
--------------------------------

M.setup = function()
  vim.api.nvim_create_user_command("LspRestart", function(info)
    local clients = info.fargs

    -- Default to restarting all active servers
    if #clients == 0 then
      clients = vim
        .iter(vim.lsp.get_clients())
        :map(function(client)
          return client.name
        end)
        :totable()
    end

    for _, name in ipairs(clients) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      else
        vim.lsp.enable(name, false)
      end
    end

    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
      for _, name in ipairs(clients) do
        vim.schedule_wrap(function(x)
          vim.lsp.enable(x)
        end)(name)
      end
    end)
  end, {
    desc = "Restart the given client",
    nargs = "?",
    complete = complete_client,
  })
end

----------

--------------------------------
-- Return Table
--------------------------------

return M
----------
