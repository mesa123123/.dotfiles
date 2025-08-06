return {
	"nvim-tree/nvim-web-devicons",
	config = function()
		local devIcons = require("nvim-web-devicons")
		local file_config = require("core").fileconfig
		devIcons.setup(file_config.set_icons)
		devIcons.set_icon(file_config.custom_icons)
		devIcons.get_icons()
	end,
}
