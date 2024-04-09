return {
"startup-nvim/startup.nvim",
event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        local dashboard_config = require("core").dashboard_config
        require("startup").setup(dashboard_config)
    end
}
