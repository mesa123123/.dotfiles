local keymaps = require('core.keymaps')

return { "folke/which-key.nvim",
           event = "VeryLazy",
          init = function()
            local wk = require("which-key")
            vim.o.timeout = true vim.o.timeoutlen = 300 
            -- local maps_for_register =  filter(vim.api.nvim_get_keymap('n'), rhs ~= nil and lhs ~= nil)
            wk.register(vim.api.nvim_get_keymap('n'))
        end, }
