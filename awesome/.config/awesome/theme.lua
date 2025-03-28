--
-- theme.lua
-- Theme config
--

local gears = require("gears")
local helpers = require("helpers")
local dpi = require("beautiful").xresources.apply_dpi

local theme = {}

-- ========================================
-- Variables
-- ========================================

-- Theme color
local color = {
    lightblue = "#8fbcbb",
    darkblue = "#2e3440",
    bg = "#1e1e2e", -- Base background
    fg = "#CDD6F4", -- Foreground text
    red = "#F38BA8", -- Red
    green = "#A6E3A1", -- Green
    yellow = "#F9E2AF", -- Yellow
    blue = "#89B4FA", -- Blue
    magenta = "#F5C2E7", -- Magenta
    cyan = "#94E2D5", -- Cyan
    white = "#BAC2DE", -- White
    black = "#11111B", -- Black
}

-- Theme font
local font = "HackGen Console"

-- ========================================
-- Icons
-- ========================================

-- Icons path
theme.icons_path = gears.filesystem.get_configuration_dir() .. "icons/"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "zafiro-icon-theme"

-- ========================================
-- Common
-- ========================================

-- Font
theme.font = font .. " 12"

-- Background
theme.bg_normal = color.bg
theme.bg_dark = color.bg
theme.bg_focus = color.blue
theme.bg_urgent = color.red
theme.bg_minimize = color.bg
theme.bg_systray = color.bg

-- Foreground
theme.fg_normal = color.white
theme.fg_focus = color.green
theme.fg_urgent = color.red
theme.fg_minimize = color.bg

-- Borders/Gaps
theme.useless_gap = dpi(7)
theme.screen_margin = theme.useless_gap
theme.border_width = dpi(4)
theme.border_radius = dpi(5)
theme.border_focus = color.blue
theme.border_marked = color.green
theme.border_normal = color.black

-- Tooltips
theme.tooltip_font = theme.font
theme.tooltip_padding_x = dpi(10)
theme.tooltip_padding_y = dpi(10)

-- Notification
theme.notification_width = dpi(350)
theme.notification_margin = dpi(15)
theme.notification_border_width = dpi(3)
theme.notification_icon_size = dpi(48)
theme.notification_border_color = color.green
theme.notification_fg = color.cyan
theme.notification_bg = color.bg
theme.notification_bg_critical = color.red
theme.notification_font = theme.font

-- ========================================
-- Components
-- ========================================

-- Topbar
theme.topbar_position = "top"
theme.topbar_height = dpi(28)
theme.topbar_margin = theme.useless_gap
theme.topbar_padding_x = dpi(5)

-- Exit screen
theme.exit_screen_bg = theme.bg_normal .. "aa"
theme.exit_screen_button_spacing = dpi(48)
theme.exit_screen_caption_spacing = dpi(8)
theme.exit_screen_icon_size = dpi(48)

-- Window switcher
theme.window_switcher_bg = theme.bg_normal .. "aa"
theme.window_switcher_margin_x = dpi(20)
theme.window_switcher_margin_y = dpi(25)
theme.window_switcher_width = dpi(500)

theme.window_switcher_spacing_x = dpi(7)
theme.window_switcher_spacing_y = dpi(15)

theme.window_switcher_icon_height = dpi(15)
theme.window_switcher_icon_width = dpi(15)

-- ========================================
-- Widgets
-- ========================================

-- Clickable container
theme.clickable_container_padding_x = dpi(10)
theme.clickable_container_padding_y = dpi(7)

-- Systray
theme.systray_icon_spacing = dpi(10)

-- Taglist
theme.taglist_spacing = dpi(5)

theme.taglist_bg_empty = theme.bg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_bg_urgent = theme.bg_normal
theme.taglist_bg_focus = theme.bg_normal

theme.taglist_fg_empty = theme.fg_normal
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_fg_urgent = theme.fg_urgent
theme.taglist_fg_focus = theme.fg_focus

-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_icon_visible = " "
theme.tasklist_icon_hidden = " "

theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent

-- Calendar
theme.calendar_padding = dpi(20)
theme.calendar_spacing = dpi(10)

-- System tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)

-- Battery
theme.battery_fg_normal = theme.fg_normal
theme.battery_fg_urgent = theme.fg_urgent

-- Layout
theme.layout_tile = theme.icons_path .. "layouts/tiled.png"
theme.layout_floating = theme.icons_path .. "layouts/floating.png"
theme.layout_max = theme.icons_path .. "layouts/maximized.png"

-- Hotkeys
theme.hotkeys_font = font .. " Bold 10"
theme.hotkeys_description_font = font .. " 10"
theme.hotkeys_bg = color.black .. "aa"
theme.hotkeys_border_width = dpi(0)
theme.hotkeys_shape = helpers.rrect
theme.hotkeys_modifiers_fg = color.yellow
theme.hotkeys_label_fg = color.white
theme.hotkeys_label_bg = color.darkblue
theme.hotkeys_group_margin = dpi(40)

return theme
