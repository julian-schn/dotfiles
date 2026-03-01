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
    "#E0E0E0",
    "#F9906F",
    "#8AB361",
    "#F0C239",
    "#4D8ACF",
    "#D08489",
    "#5FB3B3",
    "#3C4C55",
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

  -- Tab bar styling (light-theme friendly)
  tab_bar = {
    background = "#FCFDFC",

    active_tab = {
      bg_color = "#E6F0F2",
      fg_color = "#3C4C55",
      intensity = "Bold",
      underline = "Single",
    },

    inactive_tab = {
      bg_color = "#FCFDFC",
      fg_color = "#9DA8A3",
    },

    inactive_tab_hover = {
      bg_color = "#E6F0F2",
      fg_color = "#3C4C55",
    },

    new_tab = {
      bg_color = "#FCFDFC",
      fg_color = "#9DA8A3",
    },

    new_tab_hover = {
      bg_color = "#E6F0F2",
      fg_color = "#3C4C55",
    },
  },
}

-- Tabs
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = true
config.tab_max_width = 24

-- Window
config.window_padding = { left = 10, right = 10, top = 8, bottom = 8 }
config.window_decorations = "RESIZE"

-- Behavior
config.scrollback_lines = 10000
config.audible_bell = "Disabled"

-- Rendering
config.front_end = "WebGpu"
config.max_fps = 120

-- Leader
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- Keybindings
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

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = ""

  -- Detect SSH
  local process = pane.foreground_process_name
  if process and process:find("ssh") then
    title = "ssh"
  end

  -- Get cwd folder name
  local cwd_uri = pane.current_working_dir
  if cwd_uri then
    local cwd = cwd_uri.file_path
    cwd = cwd:match("([^/]+)$") or cwd
    title = cwd
  end

  -- Fallback
  if title == "" then
    title = pane.title
  end

  -- Truncate if too long
  local max = 18
  if #title > max then
    title = string.sub(title, 1, max - 1) .. "…"
  end

  return " " .. title .. " "
end)

return config
