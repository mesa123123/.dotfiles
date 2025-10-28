--------------------------------
-- ########################  --
-- #  Status Line Config  #  --
-- ########################  --
--------------------------------

--------------------------------
-- Vim, Sims, and Requires
--------------------------------

local line_utils = require("config.line_utils")

-----------------------------
-- Status Line
-----------------------------

-- Config
----------
return {
  options = {
    section_separators = { left = " ", right = " " },
    component_separators = { left = "", right = "" },
    theme = "auto",
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(res)
          return res:sub(1, 1)
        end,
      },
      line_utils.recording,
      line_utils.active_snip,
    },
    lualine_b = {
      {
        "branch",
        fmt = function(res)
          return res:sub(1, 20)
        end,
      },
      {
        "diff",
        symbols = { added = "+", modified = "~", removed = "-" },
        fmt = line_utils.trunc(120, 10000, 120, true),
      },
      {
        "diagnostics",
        symbols = { error = "", warn = "", info = "", hint = "" },
        fmt = line_utils.trunc(120, 10000, 120, true),
      },
    },
    lualine_c = {
      line_utils.virtualenv,
      {
        "filetype",
        colored = true,
        icon_only = true,
        icon = { align = "right" },
        fmt = line_utils.trunc(120, 4, 90, true),
      },
      line_utils.debug_status,
    },
    lualine_x = {
      line_utils.ai_thinking,
      line_utils.active_spell,
      line_utils.active_lsp,
      line_utils.active_lint,
      line_utils.active_formatter,
    },
    lualine_y = { { "progress", fmt = line_utils.trunc(120, 10000, 120, true) }, { "location" } },
    lualine_z = {  line_utils.zonedtime  },
		},
		winbar = {
			lualine_b = {
				{
					"filetype",
					colored = true,
					icon_only = true,
					icon = { align = "left" },
					fmt = line_utils.trunc(120, 4, 90, true),
				},
				{ "filename", file_status = true, new_file_status = true, path = 4, shorting_target = 80 },
					line_utils.get_breadcrumbs,
			},
			lualine_y = {
				{ "tabs", mode = 0, icons_enabled = true },
			},
		},
}
----------
