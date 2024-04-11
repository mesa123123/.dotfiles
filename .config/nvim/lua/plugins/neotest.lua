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
        ---------------------------------"
        -- Test Runners
        ---------------------------------"
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
        ---------------------------------"
        -- Code Coverage
        ---------------------------------"
        require("coverage").setup({
          commands = true, -- create commands
          highlights = {
            -- customize highlight groups created by the plugin
            covered = { fg = palette.bright_green }, -- supports style, fg, bg, sp (see :h highlight-gui)
            uncovered = { fg = palette.bright_red },
          },
          signs = {
            -- use your own highlight groups or text markers
            covered = { hl = "CoverageCovered", text = "▎" },
            uncovered = { hl = "CoverageUncovered", text = "▎" },
          },
          summary = {
            -- customize the summary pop-up
            min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
          },
          lang = {
            -- customize language specific settings
          },
        })
        
        -- Mappings
        ----------
        nmap(lk.exec_test_coverage.key .. "r", "Coverage", "Run Coverage Report")
        nmap(lk.exec_test_coverage.key .. "s", "CoverageSummary", "Show Coverage Report")
        nmap(lk.exec_test_coverage.key .. "t", "CoverageToggle", "Toggle Coverage Signs")
        ----------
    end
  }

