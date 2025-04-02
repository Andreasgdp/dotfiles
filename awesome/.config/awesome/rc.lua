--    ___      _____ ___  ___  __  __ _____      ____  __
--   /_\ \    / / __/ __|/ _ \|  \/  | __\ \    / /  \/  |
--  / _ \ \/\/ /| _|\__ \ (_) | |\/| | _| \ \/\/ /| |\/| |
-- /_/ \_\_/\_/ |___|___/\___/|_|  |_|___| \_/\_/ |_|  |_|
--

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local helpers = require("helpers")

Config_Dir = gears.filesystem.get_configuration_dir()

-- ========================================
-- User Config
-- ========================================

-- define default apps
Apps = {
    terminal = "ghostty",
    launcher = "rofi -show drun",
    web_browser = "brave-browser",
    volume_manager = "pavucontrol",
    network_manager = "nm-connection-editor",
    power_manager = "xfce4-power-manager",
    bluetooth_manager = "blueman-manager",
    screenshot = "flameshot gui",
    gif_recorder = "pypeek",
    screen_recorder = "simplescreenrecorder",
    filebrowser = "thunar",
}

-- network interfaces
Network_Interfaces = {
    wlan = "wlo1",
    lan = "enp0s1",
}

-- language mappings
Languages = {
    { lang = "en", engine = "xkb:us::eng" },
    { lang = "ja", engine = "mozc-jp" },
    { lang = "zh", engine = "rime" },
}

-- layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.floating,
}

-- disable maximize using signals
client.connect_signal("property::maximized", function(c)
    c.maximized = false
end)
-- disable minimize using signals
client.connect_signal("property::minimized", function(c)
    c.minimized = false
end)

-- tag configs
Tags = {
    { name = "calendar", layout = awful.layout.layouts[1] },
    { name = "web", layout = awful.layout.layouts[1] },
    { name = "chat", layout = awful.layout.layouts[1] },
    { name = "terminal", layout = awful.layout.layouts[1] },
    { name = "output", layout = awful.layout.layouts[1] },
    { name = "music", layout = awful.layout.layouts[1] },
}

-- run these commands on start up
local startup_scripts = {
    -- Faster key repeat response
    "xset r rate 200 30",
    -- Set default display setup
    "$HOME/.screenlayout/defaultDisplaySetup.sh",
    "nvidia-settings --load-config-only",
    -- Compositor
    "picom",
    -- Set wallpaper
    "feh --bg-scale "
        .. Config_Dir
        .. "/wallpapers/wheat.png",
    -- Start ibus
    "ibus-daemon -drx",
    -- Start streamdeck
    "streamdeck -n",
    "setxkbmap us altgr-intl",
    -- Start greenclip daemon (clipboard manager)
    "greenclip daemon",
    -- Start bluetooth applet
    "blueman-applet",
    -- ensure displays does not sleep
    "xset s off",
    "xset -dpms",
    "xset s noblank",
    -- Start redshift
    "redshift -l 55.237030:10.373001",
}

-- ========================================
-- Visualizations
-- ========================================

-- Load theme vars
local beautiful = require("beautiful")
beautiful.init(Config_Dir .. "theme.lua")

-- ========================================
-- Initialization
-- ========================================

-- Run all apps listed on start up
for _, app in ipairs(startup_scripts) do
    -- Don't spawn startup command if already exists
    awful.spawn.with_shell(
        string.format(
            [[ pgrep -u $USER -x %s > /dev/null || (%s) ]],
            helpers.get_main_process_name(app),
            app
        )
    )
end

-- Start daemons
require("daemons")

-- Load notifications
require("notifications")

-- Load components
require("components")

-- ========================================
-- Tags
-- ========================================

local tag_names = {}
local tag_layouts = {}

for i, tag in ipairs(Tags) do
    tag_names[i] = tag.name
    tag_layouts[i] = tag.layout
end

-- Each screen has its own tag table.
awful.screen.connect_for_each_screen(function(s)
    if s.index == 2 then
        -- Tags for screen 1
        awful.tag(
            { "web", "chat", "terminal", "music" },
            s,
            awful.layout.layouts[1]
        )
    elseif s.index == 1 then
        -- Tags for screen 2
        awful.tag({ "calendar", "output" }, s, awful.layout.layouts[1])
    end
end)

-- Remove gaps if layout is set to max
tag.connect_signal("property::layout", function(t)
    helpers.set_gaps(t.screen, t)
end)
-- Layout might change in different tag
-- so update again when switched to another tag
tag.connect_signal("property::selected", function(t)
    helpers.set_gaps(t.screen, t)
end)

-- ========================================
-- Keybindings
-- ========================================

local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- ========================================
-- Rules
-- ========================================

local rules = require("rules")
awful.rules.rules = rules

-- ========================================
-- Clients
-- ========================================

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then
        awful.client.setslave(c)
    end

    if
        awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Set rounded corners for windows
    c.shape = helpers.rrect
end)

-- Set border color of focused client
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- Focus clients under mouse
require("awful.autofocus")
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

tag.connect_signal("property::selected", function(t)
    local selected = tostring(t.selected) == "false"
    if selected then
        local focus_timer = timer({ timeout = 0.05 })
        focus_timer:connect_signal("timeout", function()
            local c = awful.mouse.client_under_pointer()
            if not (c == nil) then
                client.focus = c
                c:raise()
            end
            focus_timer:stop()
        end)
        focus_timer:start()
    end
end)

-- ========================================
-- Misc.
-- ========================================

awful.spawn.with_shell("~/.config/awesome/autostart.sh")

-- Reload config when screen geometry change
screen.connect_signal("property::geometry", awesome.restart)

-- Garbage collcetion for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
