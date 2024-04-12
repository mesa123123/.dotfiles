return {
	"rest-nvim/rest.nvim",
	ft = "http",
	dependencies = { "vhyrro/luarocks.nvim" },
	config = function()
		require("rest-nvim").setup()
		-- Requires
		----------
		local nmap = require("core.utils").norm_keyset
		local lk = require("core.keymaps").lk
		----------
		--Mappings
		----------
		nmap(lk.exec_http.key .. "x", "RestNvim", "Run Http Under Cursor")
		nmap(lk.exec_http.key .. "p", "RestNvimPreview", "Preview Curl Command From Http Under Cursor")
		nmap(lk.exec_http.key .. "x", "RestNvim", "Re-Run Last Http Command")
		----------
	end,
}
