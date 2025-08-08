return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "BurntSushi/ripgrep",
    "sharkdp/fd",
    "nvim-telescope/telescope-dap.nvim",
    "piersolenski/telescope-import.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "stevearc/oil.nvim",
    "refractalize/oil-git-status.nvim",
    "leath-dub/snipe.nvim",
  },
  event = "VeryLazy",
  config = function()
    local ftree = require("config").filetree
    require("telescope").setup(ftree.telescope_config())
    require("snipe").setup(ftree.snipe_config)
    require("oil").setup(ftree.file_tree_config)
    require("oil-git-status").setup()
    ftree.extension_load()
    ftree.set_mappings()
  end,
}
