---#########################--
-- #  Main Wezterm Config  #--
-- #########################--
--
--
--------------------------------
-- TODOS
--------------------------------
--------------------------------
--
--------------------------------
-- Requires, Variables
--------------------------------
-- Constants
----------
local background_color = "#fbf1c7"
local foreground_color = "#282828"
----------
-- Pull Wezterm API
----------
local wezterm = require("wezterm")
local config = wezterm.config_builder()
----------
--
--------------------------------
-- Mechanics Options
--------------------------------
-- Exit Prompt
----------
config.window_close_confirmation = "NeverPrompt"
----------
--------------------------------
-- Theme Settings
--------------------------------
--
-- Color Scheme
----------
config.color_scheme = "GruvboxLight"
----------
--
-- Font
----------
config.font = wezterm.font("FiraMono Nerd Font")
config.font_size = 19
----------
--
-- Title/Window Options
----------
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.window_decorations = "RESIZE"
config.native_macos_fullscreen_mode = true
config.hide_tab_bar_if_only_one_tab = true
config.colors = {
  tab_bar = {
    background = background_color,
    active_tab = {
      bg_color = background_color,
      fg_color = foreground_color,
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab_hover = {
      bg_color = background_color,
      fg_color = foreground_color,
      italic = true,
    }, -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = foreground_color,
      fg_color = background_color,
    },
    new_tab = {
      bg_color = background_color,
      fg_color = foreground_color,
    },
    new_tab_hover = {
      bg_color = foreground_color,
      fg_color = background_color,
      italic = true,
    },
  },
}
config.window_frame = {
  inactive_titlebar_bg = background_color,
  active_titlebar_bg = background_color,
  inactive_titlebar_fg = foreground_color,
  active_titlebar_fg = foreground_color,
  button_fg = foreground_color,
  button_bg = background_color,
  button_hover_fg = foreground_color,
  button_hover_bg = background_color,
}
----------
--
-- Background Settings
----------
config.macos_window_background_blur = 8
config.background = {
  {
    source = {
      Color = background_color,
    },
    width = "100%",
    height = "100%",
    opacity = 1,
  },
}
----------
--
--------------------------------
-- Keyboard Options
--------------------------------
-- Key Map Protocol
----------
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = false
----------
--
--
-- Key Bindings
----------
config.keys = {
  -- Full screen Toggle
  {
    key = "f",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ToggleFullScreen,
  },
  -- Mapping Debug Dialog
  {
    key = "b",
    mods = "CMD|SHIFT",
    action = wezterm.action.ShowDebugOverlay,
  },
  {
    key = "l",
    mods = "CMD",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "h",
    mods = "CMD",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "j",
    mods = "CMD",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "e",
    mods = "CMD",
    action = wezterm.action.DisableDefaultAssignment,
  },
}
----------

-- Return Module
----------
return config
----------
