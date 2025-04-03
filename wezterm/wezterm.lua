-- Pull in the wezterm API
local wezterm = require("wezterm")
-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local act = wezterm.action
-- This is where you actually apply your config choices
config.leader = {
	key = "a",
	mods = "CTRL",
}
config.keys = {
	{
		key = "I",
		mods = "CTRL",
		action = wezterm.action.PaneSelect({
			show_pane_ids = true,
		}),
	},
	{
		key = "Z",
		mods = "CTRL",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "h",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Left", 3 }),
	},
	{
		key = "l",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Right", 3 }),
	},
	{
		key = "j",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Down", 3 }),
	},
	{
		key = "k",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Up", 3 }),
	},
	{
		key = "=",
		mods = "CTRL|ALT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "CTRL|ALT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "n",
		mods = "SHIFT|CTRL",
		action = act.ToggleFullScreen,
	},
}

config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.show_tabs_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = false
config.tab_and_split_indices_are_zero_based = false
config.tab_bar_at_bottom = true
config.tab_max_width = 25
config.use_fancy_tab_bar = false

-- For example, changing the color scheme:
config.color_scheme = "Kanagawa (Gogh)"
config.window_decorations = "RESIZE"
config.font_size = 16
-- and finally, return the configuration to wezterm
return config
