icons = require("core").icons

return {
      "nvim-tree/nvim-web-devicons",
      config = function()
	local devIcons = require("nvim-web-devicons")
	devIcons.setup(icons.config)
	devIcons.set_icon(icons.custom_icons)
	devIcons.get_icons()
      end

}
