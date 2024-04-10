return {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio", 
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "andythigpen/nvim-coverage",
    },
    event = "VeryLazy",
    config = function()
        local utils = require("core.utils") 
        local nmap = utils.norm_keyset
        local lk = require("core.keymaps").lk
        local get_python_path = utils.get_python_path
        require("neotest").setup({
          adapters = {
            require("neotest-python")({
              dap = { justMyCode = false },
              runner = "pytest",
              python = get_python_path(),
              pytest_discover_instances = true,
              args = { "-vv" },
            }),
          },
          status = {
            enabled = true,
            virtual_text = true,
            signs = false,
          },
        })

        -- Mappings
        ----------
        -- Mappings
        nmap(lk.exec_test.key .. "x", "lua require('neotest').run.run(vim.fn.expand('%'))", "Test Current Buffer")
        nmap(lk.exec_test.key .. "o", "lua require('neotest').output.open({ enter = true, auto_close = true })", "Test Output")
        nmap(lk.exec_test.key .. "s", "lua require('neotest').summary.toggle()", "Test Output (All Tests)")
        nmap(lk.exec_test.key .. "q", "lua require('neotest').run.stop()", "Quit Test Run")
        nmap(lk.exec_test.key .. "w", "lua require('neotest').watch.toggle(vim.fn.expand('%'))", "Toggle Test Refreshing")
        nmap(lk.exec_test.key .. "c", "lua require('neotest').run.run()", "Run Nearest Test")
        nmap(lk.exec_test.key .. "r", "lua require('neotest').run.run_last()", "Repeat Last Test Run")
        nmap(
          lk.exec_test.key .. "b",
          "lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})",
          "Debug Closest Test"
        )
        ----------
    end
  }

