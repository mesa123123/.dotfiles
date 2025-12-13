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
  -- LspRestart
  ------------
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

    local timer = assert(vim.fn.new_timer())
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
  ----------
  -- DB Functions
  ----------
  -- Close MiniStarter If Open
  vim.api.nvim_create_user_command("CloseMiniStarter", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
      if ft == "ministarter" or ft == "starter" then
        MiniStarter.close(buf)
        return true
      end
    end
  end, {})
  -- Open UI in new tab
  vim.api.nvim_create_user_command("OpenDBInNewTab", function()
    vim.cmd("tabnew<CR>")
    vim.cmd("DBUIToggle")
    vim.cmd("set nu")
    vim.cmd("set relativenumber")
    vim.cmd("CloseMiniStarter")
  end, {})
  -- Open DB In Current Tab
  vim.api.nvim_create_user_command("OpenDBInThisTab", function()
    vim.cmd("DBUIToggle")
    vim.cmd("set nu")
    vim.cmd("set relativenumber")
    vim.cmd("CloseMiniStarter")
  end, {})
  --
  -- Move dbout to csv file
  vim.api.nvim_create_user_command("DBResulttoCSV", function(cmd_opts)
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local filename = "dbout_" .. timestamp .. "_result.csv"
    vim.cmd(":$")
    vim.cmd("/^+------")
    vim.cmd("normal! yG")
    vim.cmd("vs " .. filename)
    vim.cmd("normal! P")
    vim.cmd("%s/^| //")
    vim.cmd("%s/ | /,/g")
    vim.cmd("%s/^+------.*$//")
    vim.cmd("g/^\\s*$/d")
    vim.cmd("RainbowAlign")
    vim.cmd("bufdo if &filetype == 'dbout' | bdelete! | endif")
  end, { range = true, desc = "Move DB output to a new CSV file" })
  ----------

  -- Workspace Setup
  ----------
  vim.api.nvim_create_autocmd({ "VimLeavePre", "FocusLost" }, {
    callback = function()
      if vim.fn.filereadable(vim.fn.getcwd() .. "/.nvim.lua") then
        vim.cmd.mksession({ bang = true })
        vim.o.shadafile = "./local.shada"
        vim.cmd.wshada({ bang = true })
      end
    end,
  })
  -- Option to Load Sessions In Nvim
  local function load_project_session()
    local session_file = "Session.vim"

    if vim.fn.filereadable(session_file) == 1 then
      -- Load the session file using :source
      vim.cmd("silent! source " .. session_file)

      -- Optional: clean up the initial empty buffer (usually buffer 1)
      -- This prevents an extra empty buffer from hanging around.
      vim.cmd("silent! bdelete 1")

      vim.notify("Project session loaded from Session.vim.", vim.log.levels.INFO)
    else
      vim.notify("No Session.vim found in current directory.", vim.log.levels.WARN)
    end
  end
  vim.api.nvim_create_user_command("LoadProjectSession", load_project_session, {
    desc = "Loads Session.vim from the current directory",
  })
  ----------
end
----------

--------------------------------
-- Return Table
--------------------------------

return M
----------
