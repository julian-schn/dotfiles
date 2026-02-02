local wezterm = require("wezterm")
local config = {}

-- Font
config.font = wezterm.font({
  family = "Iosevka",
  weight = "Regular",
})
config.font_size = 12.5
config.line_height = 1.1
config.freetype_load_flags = "NO_HINTING"

-- Danqing Light (manual palette)
config.colors = {
  foreground = "#3C4C55",
  background = "#FCFDFC",

  cursor_bg = "#3C4C55",
  cursor_fg = "#FCFDFC",
  cursor_border = "#3C4C55",

  selection_fg = "#3C4C55",
  selection_bg = "#E6F0F2",

  ansi = {
    "#E0E0E0", -- black
    "#F9906F", -- red
    "#8AB361", -- green
    "#F0C239", -- yellow
    "#4D8ACF", -- blue
    "#D08489", -- magenta
    "#5FB3B3", -- cyan
    "#3C4C55", -- white
  },

  brights = {
    "#9DA8A3",
    "#F9906F",
    "#8AB361",
    "#F0C239",
    "#4D8ACF",
    "#D08489",
    "#5FB3B3",
    "#2F3E46",
  },
}

-- Window
config.window_padding = { left = 10, right = 10, top = 8, bottom = 8 }
config.window_decorations = "RESIZE"
config.enable_tab_bar = false

-- Behavior
config.scrollback_lines = 10000
config.audible_bell = "Disabled"

-- Rendering
config.front_end = "WebGpu"
config.max_fps = 120

-- Keybindings (mac-friendly)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- Pane splitting
  { key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal },
  { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical },

  -- Pane navigation
  { key = "LeftArrow",  mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "UpArrow",    mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "DownArrow",  mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Down") },

  -- Close pane
  { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
}

return config
