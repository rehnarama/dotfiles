-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 15.0
config.color_scheme = "Catppuccin Latte"
config.use_fancy_tab_bar = false
config.keys = {
{
	key = "p",
	mods = "CTRL | SHIFT",
	action = wezterm.action.DisableDefaultAssignment,
},
	{
		key = "P",
		mods = "CTRL | SHIFT",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "n",
		mods = "CTRL | SHIFT",
		action = wezterm.action.ActivateCommandPalette,
	},
}

config.default_prog = { "/usr/local/bin/fish", "-l" }

-- and finally, return the configuration to wezterm
return config
