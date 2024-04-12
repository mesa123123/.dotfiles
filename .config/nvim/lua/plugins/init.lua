return {
	{
		"vhyrro/luarocks.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		priority = 1000,
		config = true,
	},
	----------
	-- Autocompletion & Snips
	----------
	{ "L3MON4D3/LuaSnip", dependencies = {
		"rafamadriz/friendly-snippets",
	} },
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"ray-x/cmp-treesitter",
			"SergioRibera/cmp-dotenv",
			"dmitmel/cmp-cmdline-history",
			"yochem/cmp-htmx",
			"saadparwaiz1/cmp_luasnip",
			"f3fora/cmp-spell",
			"jmbuhr/otter.nvim",
		},
	},
	----------
	-- Language Server Protocol
	----------
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"williamboman/mason.nvim",
			"ray-x/lsp_signature.nvim",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
		},
	},
	{ "jose-elias-alvarez/null-ls.nvim", branch = "main" },
	-- Linting Plugins
	----------
	{ "mfussenegger/nvim-lint", event = "VeryLazy" },
	-- Formatting
	----------
	{ "stevearc/conform.nvim", event = "VeryLazy" },
	-- Inejected Languages
	----------
	"jmbuhr/otter.nvim",
	-- Debug Adapter Protocol
	----------
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- Python Funcs
			"mfussenegger/nvim-dap-python",
			-- NvimConfig Funcs
			"jbyuki/one-small-step-for-vimkind",
			-- Cool Ui Elements
			"theHamsta/nvim-dap-virtual-text",
		},
	},
	----------
	-- Versions Control
	----------
	-- nicer-looking tabs with close icons
	{
		"nanozuki/tabby.nvim",
		enabled = true,
		config = function()
			require("tabby.tabline").use_preset("tab_only")
		end,
	},
	{
		"dstein64/nvim-scrollview",
		enabled = true,
		opts = {
			current_only = true,
			signs_on_startup = {},
		},
	},
	{
		"utilyre/barbecue.nvim",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		config = function()
			require("barbecue").setup()
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"folke/zen-mode.nvim",
		config = function()
			require("core.utils").norm_keyset(
				require("core.keymaps").lk.zen.key,
				'lua require("zen-mode").toggle({ window = { width = .85 }})',
				"Zen Mode Toggle"
			)
		end,
	},
	{
		"cameron-wags/rainbow_csv.nvim",
		config = true,
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
		cmd = {
			"RainbowDelim",
			"RainbowDelimSimple",
			"RainbowDelimQuoted",
			"RainbowMultiDelim",
		},
	},
	{ "onsails/lspkind.nvim", event = "VeryLazy" },
	-- Dashboard
	{
		"startup-nvim/startup.nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	-- Folding
	----------
	{
		"anuvyklack/pretty-fold.nvim",
		config = function()
			require("pretty-fold").setup({})
		end,
	},
	----------
	-- CmdLine
	----------
	"rcarriga/nvim-notify",
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	----------
	-- Writing Functionality
	----------
	-- Wiki - Obsidian nvim
	{ "epwalsh/obsidian.nvim", event = "VeryLazy" },
	-- Latex - VimTex
	{
		"lervag/vimtex",
		config = function()
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.tex" },
				callback = function()
					vim.g["vimtext_view_method"] = "zathura"
				end,
			})
		end,
	},
	----------
	-- Working with Kitty
	----------
	{ "fladson/vim-kitty", branch = "main" },
	----------
	-- Notebooks
	----------
	--  {
	--    "quarto-dev/quarto-nvim",
	--  },
	--  {
	--    "benlubas/molten-nvim",
	--    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
	--    build = ":UpdateRemotePlugins",
	--    init = function()
	--      -- this is an example, not a default. Please see the readme for more configuration options
	--      vim.g.molten_output_win_max_height = 12
	--    end,
	--  },
	--  ----------
	-- Vim tutor Ext
	"ThePrimeagen/vim-be-good",
}
