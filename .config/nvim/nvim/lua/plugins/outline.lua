return {
  "hedyhli/outline.nvim",
  config = function()
    local utils = require("config.utils")
    local descMap = utils.desc_keymap
    local lk = require("config.keymaps").lk
    descMap({ "n" }, lk.explore, "e", ":Outline<CR>", "Outline")
    require("outline").setup({
      outline_window = {
        show_numbers = true,
        show_relative_numbers = true,
      },
    })
  end,
}
