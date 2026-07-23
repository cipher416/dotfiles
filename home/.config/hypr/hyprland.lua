local home = os.getenv("HOME")
local terminal = "ghostty"
local menu = "vicinae toggle"
local file_manager = "dolphin"
local browser = "gtk-launch app.zen_browser.zen"

-- Preserve the current KDE display layout, with a fallback for other displays.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

hl.monitor({
  output = "HDMI-A-2",
  mode = "highrr",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "DP-5",
  mode = "preferred",
  position = "1920x0",
  scale = 1,
})

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "macOS")
hl.env("HYPRCURSOR_THEME", "macOS-hypr")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")

hl.config({
  general = {
    gaps_in = 6,
    gaps_out = 12,
    border_size = 1,
    col = {
      active_border = "rgb(ededed)",
      inactive_border = "rgb(262626)",
    },
    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    rounding = 8,
    active_opacity = 1,
    inactive_opacity = 0.96,
    shadow = {
      enabled = true,
      range = 12,
      render_power = 3,
      color = "rgba(00000099)",
    },
    blur = {
      enabled = true,
      size = 4,
      passes = 2,
      vibrancy = 0,
    },
  },

  group = {
    groupbar = {
      font_family = "SF Pro Text",
      font_size = 11,
      font_weight_active = "medium",
      font_weight_inactive = "light",
    },
  },

  animations = { enabled = true },

  input = {
    kb_layout = "us",
    kb_options = "",
    follow_mouse = 1,
    sensitivity = 0,
    repeat_rate = 40,
    repeat_delay = 250,
    numlock_by_default = true,
  },

  dwindle = {
    preserve_split = true,
    force_split = 2,
  },

  scrolling = {
    column_width = 0.49,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    disable_scale_notification = true,
    force_default_wallpaper = 0,
    focus_on_activate = true,
    key_press_enables_dpms = true,
    mouse_move_enables_dpms = true,
  },

  cursor = {
    hide_on_key_press = true,
    warp_on_change_workspace = 1,
  },

  binds = {
    hide_special_on_workspace_change = true,
  },

  xwayland = {
    force_zero_scaling = true,
  },

  ecosystem = {
    no_update_news = true,
  },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.4, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.8, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 92%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "linear", style = "popin 92%" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "workspaces", enabled = false })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("mako")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-- Applications and Omarchy-style menus.
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd(file_manager))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(terminal .. " -e nvim"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("zed"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("cursor"))
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd(terminal .. " -e lazydocker"))
hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd(terminal .. " -e btop"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + R", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd(home .. "/.local/bin/hypr-menu system"))
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd(home .. "/.local/bin/hypr-menu system"))
hl.bind("SUPER + K", hl.dsp.exec_cmd(home .. "/.local/bin/hypr-menu keybindings"))
hl.bind("SUPER + CTRL + V", hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))

-- Window and workspace navigation.
hl.bind("SUPER + W", hl.dsp.window.close())
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind("SUPER + LEFT", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + UP", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + DOWN", hl.dsp.focus({ direction = "d" }))

hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.swap({ direction = "l" }))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "r" }))
hl.bind("SUPER + SHIFT + UP", hl.dsp.window.swap({ direction = "u" }))
hl.bind("SUPER + SHIFT + DOWN", hl.dsp.window.swap({ direction = "d" }))

for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = tostring(workspace) }))
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(workspace) }))
  hl.bind("SUPER + SHIFT + ALT + " .. key, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
end

hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + CTRL + TAB", hl.dsp.focus({ workspace = "previous" }))
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))
hl.bind("CTRL + ALT + TAB", hl.dsp.focus({ monitor = "+1" }))
hl.bind("CTRL + ALT + SHIFT + TAB", hl.dsp.focus({ monitor = "-1" }))

hl.bind("SUPER + code:20", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
hl.bind("SUPER + code:21", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
hl.bind("SUPER + SHIFT + code:20", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
hl.bind("SUPER + SHIFT + code:21", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("SUPER + ALT + G", hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + ALT + TAB", hl.dsp.group.next())
hl.bind("SUPER + ALT + SHIFT + TAB", hl.dsp.group.prev())

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Universal clipboard shortcuts use terminal-safe key combinations.
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down", window = "activewindow" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up", window = "activewindow" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

local terminal_classes = {
  ["com.mitchellh.ghostty"] = true,
  ghostty = true,
  kitty = true,
  alacritty = true,
}

local function universal_shortcut(default_mods, default_key, terminal_mods, terminal_key)
  return function()
    local window = hl.get_active_window()
    local class = window and window.class and window.class:lower() or ""
    if terminal_classes[class] then
      send_shortcut_once(terminal_mods, terminal_key)()
    else
      send_shortcut_once(default_mods, default_key)()
    end
  end
end

hl.bind("SUPER + C", universal_shortcut("CTRL", "C", "CTRL", "Insert"))
hl.bind("SUPER + V", universal_shortcut("CTRL", "V", "SHIFT", "Insert"))
hl.bind("SUPER + X", send_shortcut_once("CTRL", "X"))

-- Capture, lock, notifications, bar, audio, and media.
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region -z"))
hl.bind("PRINT", hl.dsp.exec_cmd(home .. "/.local/bin/hypr-screenshot"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd(home .. "/.local/bin/hypr-screenshot full"))
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + comma", hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind("SUPER + SHIFT + comma", hl.dsp.exec_cmd("makoctl dismiss --all"))
hl.bind("SUPER + SHIFT + SPACE", hl.dsp.exec_cmd(home .. "/.local/bin/hypr-waybar-toggle"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

hl.layer_rule({
  match = { namespace = "vicinae" },
  name = "vicinae-blur",
  blur = true,
  ignore_alpha = 0,
})

hl.layer_rule({
  match = { namespace = "vicinae" },
  name = "vicinae-no-animation",
  no_anim = true,
})
