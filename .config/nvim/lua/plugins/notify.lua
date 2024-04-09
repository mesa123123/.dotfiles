return {
      "rcarriga/nvim-notify",
      event = "VeryLazy",
      config = function()
        local hl = vim.api.nvim_set_hl
        local notify = require("notify")
        local palette = require("core.theme").palette
        notify.setup({
          render = "simple",
          timeout = 200,
          stages = "fade",
          minimum_width = 25,
          top_down = true,
          background_color = palette.dark0_hard
        })
        hl(0, "NotifyBackground", { bg = palette.dark0_hard })
     end
}
