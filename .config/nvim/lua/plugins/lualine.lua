local line_config = require("core").line_config

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
	    require('lualine').setup(line_config)
    end
}


