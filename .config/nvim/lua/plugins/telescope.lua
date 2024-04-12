return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"BurntSushi/ripgrep",
		"sharkdp/fd",
		"nvim-telescope/telescope-dap.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"piersolenski/telescope-import.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	event = "VeryLazy",
	config = function()
		local ftree = require("core").filetree
		require("telescope").setup(ftree.telescope_config())
		ftree.extension_load()
		ftree.set_mappings()
	end,
}
