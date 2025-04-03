--
-- key.lua
-- Keybindings and buttons
--

local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Define mod keys
local modkey = "Mod4"
local altkey = "Mod1"
local ctrlkey = "Control"
local shiftkey = "Shift"

-- Define mouse button
local leftclick = 1
local midclick = 2
local rightclick = 3
local scrolldown = 4
local scrollup = 5
local sidedownclick = 8
local sideupclick = 9

local keys = {}

keys.modkey = modkey
keys.altkey = altkey
keys.ctrlkey = ctrlkey
keys.shiftkey = shiftkey

keys.leftclick = leftclick
keys.midclick = midclick
keys.rightclick = rightclick
keys.scrolldown = scrolldown
keys.scrollup = scrollup
keys.sidedownclick = sidedownclick
keys.sideupclick = sideupclick

-- ========================================
-- Movement functions
-- ========================================

-- Move local client
local function move_client(c, direction)
    -- If client is floating, move to edge
    if
        c.floating
        or (awful.layout.get(mouse.screen) == awful.layout.suit.floating)
    then
        -- If maxed layout then swap windows
        local workarea = awful.screen.focused().workarea
        if direction == "up" then
            c:geometry({
                nil,
                y = workarea.y + beautiful.useless_gap * 2,
                nil,
                nil,
            })
        elseif direction == "down" then
            c:geometry({
                nil,
                y = workarea.height
                    + workarea.y
                    - c:geometry().height
                    - beautiful.useless_gap * 2
                    - beautiful.border_width * 2,
                nil,
                nil,
            })
        elseif direction == "left" then
            c:geometry({
                x = workarea.x + beautiful.useless_gap * 2,
                nil,
                nil,
                nil,
            })
        elseif direction == "right" then
            c:geometry({
                x = workarea.width
                    + workarea.x
                    - c:geometry().width
                    - beautiful.useless_gap * 2
                    - beautiful.border_width * 2,
                nil,
                nil,
                nil,
            })
        end
    else
        awful.client.swap.global_bydirection(direction, c)
    end
end

-- Resize local client
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
    if
        awful.layout.get(mouse.screen) == awful.layout.suit.floating
        or (c and c.floating)
    then
        if direction == "up" then
            c:relative_move(0, 0, 0, -floating_resize_amount)
        elseif direction == "down" then
            c:relative_move(0, 0, 0, floating_resize_amount)
        elseif direction == "left" then
            c:relative_move(0, 0, -floating_resize_amount, 0)
        elseif direction == "right" then
            c:relative_move(0, 0, floating_resize_amount, 0)
        end
    else
        if direction == "up" then
            awful.client.incwfact(-tiling_resize_factor)
        elseif direction == "down" then
            awful.client.incwfact(tiling_resize_factor)
        elseif direction == "left" then
            awful.tag.incmwfact(-tiling_resize_factor)
        elseif direction == "right" then
            awful.tag.incmwfact(tiling_resize_factor)
        end
    end
end

-- Raise focus client
local function raise_client()
    if client.focus then
        client.focus:raise()
    end
end

-- ========================================
-- Mouse bindings
-- ========================================

-- Mouse buttons on desktop
keys.desktopbuttons = gears.table.join(awful.button({}, leftclick, function()
    naughty.destroy_all_notifications()
end))

-- Mouse buttons on client
keys.clientbuttons = gears.table.join(
    awful.button({}, leftclick, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, leftclick, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, rightclick, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- ========================================
-- Client Keybindings
-- ========================================

keys.clientkeys = gears.table.join(
    awful.key({ modkey, shiftkey }, "j", function(c)
        move_client(c, "down")
    end, { description = "move down", group = "client" }),
    awful.key({ modkey, shiftkey }, "k", function(c)
        move_client(c, "up")
    end, { description = "move up", group = "client" }),
    awful.key({ modkey, shiftkey }, "h", function(c)
        move_client(c, "left")
    end, { description = "move left", group = "client" }),
    awful.key({ modkey, shiftkey }, "l", function(c)
        move_client(c, "right")
    end, { description = "move right", group = "client" }),
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey }, "t", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, shiftkey }, "c", function(c)
        c:kill()
    end, { description = "close", group = "client" }),
    awful.key({ modkey }, "q", function(c)
        c:kill()
    end, { description = "close", group = "client" }),
    awful.key(
        { modkey, ctrlkey },
        "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    awful.key({ modkey }, "w", awful.client.floating.toggle, {
        description = "toggle floating",
        group = "client",
    }),
    awful.key({ modkey, "Control" }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, {
        description = "move to master",
        group = "client",
    })
)

-- ========================================
-- Global Keybindings
-- ========================================

keys.globalkeys = gears.table.join(
    -- ========================================
    -- Awesome General
    -- ========================================
    awful.key(
        { modkey, shiftkey },
        "/",
        hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }
    ),
    awful.key(
        { modkey, ctrlkey },
        "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),

    awful.key({ modkey }, "Escape", function()
        awful.spawn("lock")
    end, {
        description = "lock Screen",
        group = "awesome",
    }),
    awful.key({ modkey, shiftkey }, "Escape", function()
        awesome.emit_signal("exit_screen::show")
    end, { description = "show exit screen", group = "awesome" }),
    awful.key({}, "XF86PowerOff", function()
        awesome.emit_signal("exit_screen::show")
    end, { description = "show exit screen", group = "awesome" }),
    awful.key({ modkey }, "Tab", function()
        awful.screen.focused().window_switcher:show()
    end, { description = "activate window switcher", group = "awesome" }),
    awful.key({ altkey }, "Tab", function()
        awful.screen.focused().window_switcher:show()
    end, { description = "activate window switcher", group = "awesome" }),
    awful.key({ modkey }, "=", function()
        awesome.emit_signal("widget::systray::toggle")
    end, { description = "toggle systray", group = "awesome" }),
    awful.key({ modkey, shiftkey }, "p", function()
        awful.spawn.with_shell(Config_Dir .. "/scripts/toggle-picom.sh")
    end, { description = "toggle picom", group = "awesome" }),
    awful.key({ modkey }, "u", function()
        -- if no urgent client, move the cursor to the center of the focused client
        if awful.client.urgent.get() == nil then
            helpers.move_mouse_onto_focused_client(client.focus)
        else
            awful.client.urgent.jumpto()
        end
    end, { description = "jump to urgent client", group = "client" }),
    -- ========================================
    -- Screen focus
    -- ========================================
    awful.key({ modkey, ctrlkey }, "s", function()
        awful.screen.focus_relative(1)
    end, { description = "focus next screen", group = "screen" }),
    awful.key({ modkey, ctrlkey }, "S", function()
        awful.screen.focus_relative(-1)
    end, { description = "focus previous screen", group = "screen" }),
    -- ========================================
    -- Client focus
    -- ========================================
    awful.key({ modkey }, "j", function()
        awful.client.focus.bydirection("down")
        raise_client()
        helpers.move_mouse_onto_focused_client(client.focus)
    end, { description = "focus down", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.bydirection("up")
        raise_client()
        helpers.move_mouse_onto_focused_client(client.focus)
    end, { description = "focus up", group = "client" }),
    awful.key({ modkey }, "h", function()
        awful.client.focus.bydirection("left")
        raise_client()
        helpers.move_mouse_onto_focused_client(client.focus)
    end, { description = "focus left", group = "client" }),
    awful.key({ modkey }, "l", function()
        awful.client.focus.bydirection("right")
        raise_client()
        helpers.move_mouse_onto_focused_client(client.focus)
    end, { description = "focus right", group = "client" }),
    -- ========================================
    -- Client resize
    -- ========================================
    awful.key({ modkey, ctrlkey }, "j", function()
        resize_client(client.focus, "down")
    end, { description = "resize down", group = "client" }),
    awful.key({ modkey, ctrlkey }, "k", function()
        resize_client(client.focus, "up")
    end, { description = "resize up", group = "client" }),
    awful.key({ modkey, ctrlkey }, "h", function()
        resize_client(client.focus, "left")
    end, { description = "resize left", group = "client" }),
    awful.key({ modkey, ctrlkey }, "l", function()
        resize_client(client.focus, "right")
    end, { description = "resize right", group = "client" }),
    awful.key({ modkey, shiftkey }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal(
                "request::activate",
                "key.unminimize",
                { raise = true }
            )
        end
    end, { description = "restore minimized", group = "client" }),
    -- ========================================
    -- Gap control
    -- ========================================
    awful.key({ modkey, shiftkey }, "minus", function()
        awful.tag.incgap(5, nil)
    end, {
        description = "increment gaps size for current tag",
        group = "tag",
    }),
    awful.key({ modkey }, "minus", function()
        awful.tag.incgap(-5, nil)
    end, {
        description = "decrement gaps size for current tag",
        group = "tag",
    }),
    -- ========================================
    -- Rofi Utilities
    -- ========================================
    awful.key({ modkey }, ".", function()
        awful.spawn("rofi -modi emoji -show emoji -kb-custom-1 Ctrl+C")
    end, {
        description = "rofi emoji",
        group = "launcher",
    }),
    awful.key({ modkey }, "v", function()
        awful.spawn(
            "rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'"
        )
    end, {
        description = "rofi clipboard",
        group = "launcher",
    }),

    -- ========================================
    -- Applications
    -- ========================================

    -- Macro keybinding
    awful.key({ modkey, shiftkey }, "m", function()
        -- Define the sequence of key presses
        local key_sequence = {
            "Super_L+1",
            "Super_L+a",
            "Super_L+a",
            "Super_L+2",
            "Super_L+y",
            "Super_L+3",
            "Super_L+d",
            "Super_L+i",
            "Super_L+m",
            "Super_L+4",
            "Super_L+Return",
            "Super_L+5",
            "Super_L+b",
            "Super_L+2",
        }

        if not helpers.is_personal_desktop() then
            key_sequence = {
                "Super_L+1",
                "Super_L+a",
                "Super_L+a",
                "Super_L+2",
                "Super_L+b",
                "Super_L+3",
                "Super_L+t",
                "Super_L+i",
                "Super_L+4",
                "Super_L+Return",
                "Super_L+5",
                "Super_L+b",
                "Super_L+2",
            }
        end

        -- Function to simulate key presses with a delay
        local function simulate_key_sequence(keys, index, delay)
            if index > #keys then
                return
            end
            awful.util.spawn("xdotool key --clearmodifiers " .. keys[index])
            gears.timer.start_new(delay, function()
                simulate_key_sequence(keys, index + 1, delay)
                return false
            end)
        end

        -- Start the sequence with a delay of 0.2 seconds between each key press
        simulate_key_sequence(key_sequence, 1, 0.5)
    end, { description = "macro sequence", group = "custom" }),
    awful.key({ modkey }, "`", function()
        awesome.emit_signal("floating_terminal::toggle")
    end, { description = "toggle floating terminal", group = "hotkeys" }),
    awful.key({ modkey }, "Return", function()
        awful.spawn(Apps.terminal)
    end, { description = "terminal", group = "hotkeys" }),
    awful.key({ modkey }, "e", function()
        awful.spawn.with_shell(
            [[ notify-send "Current Weather" "$(curl "wttr.in?T0")" ]]
        )
    end, { description = "get current weather", group = "hotkeys" }),
    awful.key({ modkey }, "p", function()
        awful.spawn(Apps.launcher)
    end, { description = "application launcher", group = "hotkeys" }),
    awful.key({ modkey }, "b", function()
        awful.spawn(Apps.web_browser)
    end, { description = "web browser", group = "hotkeys" }),
    awful.key({ modkey }, "n", function()
        awful.spawn(Apps.web_browser)
    end, { description = "web browser", group = "hotkeys" }),
    awful.key({ modkey }, "a", function()
        awful.spawn(
            "brave-browser --app=https://web.akiflow.com/#/planner/today"
        )
    end, {
        description = "open akiflow",
        group = "launcher",
    }),
    awful.key({ modkey }, "t", function()
        awful.spawn("brave-browser --app=https://teams.microsoft.com")
    end, { description = "open Microsoft Teams", group = "launcher" }),
    awful.key({ modkey }, "space", function()
        awful.util.spawn(
            "bash -c " .. Config_Dir .. "'/scripts/akiflow-command-bar.sh'"
        )
    end, {
        description = "open akiflow command bar",
        group = "awesome",
    }),
    awful.key({ modkey }, "d", function()
        helpers.focus_or_open(
            "discord",
            "discord --no-sandbox --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy"
        )
    end, {
        description = "open discord",
        group = "launcher",
    }),
    awful.key({ modkey }, "m", function()
        helpers.focus_or_open(
            "Messenger | Facebook - Brave",
            Apps.web_browser
                .. " --new-window https://www.facebook.com/messages"
        )
    end, {
        description = "open messenger",
        group = "launcher",
    }),
    awful.key({ modkey }, "y", function()
        helpers.focus_or_open(
            "Subscriptions - YouTube - Brave",
            Apps.web_browser
                .. " --new-window https://www.youtube.com/feed/subscriptions"
        )
    end, {
        description = "open youtube subscriptions",
        group = "launcher",
    }),
    awful.key({ modkey }, "i", function()
        if helpers.is_personal_desktop() then
            awful.spawn("brave-browser --new-window https://app.shortwave.com/")
        else
            awful.spawn(
                "brave-browser --new-window https://outlook.office.com/mail/inbox"
            )
        end
    end, {
        description = "open outlook inbox",
        group = "launcher",
    }),

    awful.key({ modkey }, "s", function()
        helpers.focus_or_open("Spotify", "spotify")
    end, {
        description = "open spotify",
        group = "launcher",
    }),

    -- ========================================
    -- Screenshot
    -- ========================================
    awful.key({}, "Print", function()
        awful.spawn.with_shell(Apps.screenshot)
        naughty.notify({
            icon = beautiful.icons_path .. "screenshot.svg",
            title = "Screenshot",
            text = "Screenshot of screen stored in clipboard.",
        })
    end, { description = "take a screenshot", group = "hotkeys" }),

    -- ========================================
    -- Recording
    -- ========================================
    awful.key({ modkey }, "Print", function()
        awful.spawn.with_shell(
            Apps.gif_recorder .. " | xclip -sel clip -t image/gif"
        )
        naughty.notify({
            icon = beautiful.icons_path .. "recording.svg",
            title = "GIF Recorder",
            text = "GIF recording started.",
        })
    end, { description = "start GIF recording", group = "recording" }),

    awful.key({ modkey, shiftkey }, "Print", function()
        awful.spawn.with_shell(Apps.screen_recorder)
        naughty.notify({
            icon = beautiful.icons_path .. "recording.svg",
            title = "Screen Recorder",
            text = "Screen recording started.",
        })
    end, { description = "start screen recording", group = "recording" }),
    -- ========================================
    -- Function keys
    -- ========================================
    -- Brightness
    awful.key({}, "XF86MonBrightnessUp", function()
        helpers.change_brightness(5)
    end, { description = "brightness up", group = "hotkeys" }),
    awful.key({}, "XF86MonBrightnessDown", function()
        helpers.change_brightness(-5)
    end, { description = "brightness down", group = "hotkeys" }),
    -- Volume/Playback
    awful.key({}, "XF86AudioRaiseVolume", function()
        helpers.change_volume(5)
    end, { description = "volume up", group = "hotkeys" }),
    awful.key({}, "XF86AudioLowerVolume", function()
        helpers.change_volume(-5)
    end, { description = "volume down", group = "hotkeys" }),
    awful.key(
        {},
        "XF86AudioMute",
        helpers.toggle_volume_mute,
        { description = "toggle mute", group = "hotkeys" }
    ),
    awful.key(
        {},
        "XF86AudioNext",
        helpers.media_next,
        { description = "next track", group = "hotkeys" }
    ),
    awful.key(
        {},
        "XF86AudioPrev",
        helpers.media_prev,
        { description = "previous track", group = "hotkeys" }
    ),
    awful.key(
        {},
        "XF86AudioPlay",
        helpers.media_play_pause,
        { description = "play/pause music", group = "hotkeys" }
    )
)

-- mapper to map numbers to tag index
-- 1=1, 2=1, 3=2, 4=3, 5=2, 6=4
local tagMapper = {
    [1] = { screen = 1, tag = 1 },
    [2] = { screen = 2, tag = 1 },
    [3] = { screen = 2, tag = 2 },
    [4] = { screen = 2, tag = 3 },
    [5] = { screen = 1, tag = 2 },
    [6] = { screen = 2, tag = 4 },
}

-- Bind all key numbers to tags
for i = 1, #Tags do
    local tag_name = string.format("#%s: %s", i, Tags[i].name)

    keys.globalkeys = gears.table.join(
        keys.globalkeys,
        -- Switch to tags
        awful.key({ modkey }, "#" .. i + 9, function()
            if helpers.is_screen_count(1) then
                local screen = awful.screen.focused()
                local tag = screen.tags[i]

                if tag then
                    tag:view_only()
                end
                return
            end

            local localScreen, tag
            local mapping = tagMapper[i]

            if mapping then
                localScreen = screen[mapping.screen]
                tag = localScreen.tags[mapping.tag]
            end

            if tag then
                local geometry = localScreen.geometry
                local x = geometry.x + geometry.width / 2
                local y = geometry.y + geometry.height / 2
                mouse.coords({ x = x, y = y }, true)

                tag:view_only()
                -- focus the first client on the tag
                local clients = tag:clients()
                if clients[1] then
                    clients[1]:emit_signal(
                        "request::activate",
                        "key.unminimize",
                        { raise = true }
                    )
                end
            end
        end, { description = "view tag " .. tag_name, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, shiftkey }, "#" .. i + 9, function()
            if client.focus then
                if helpers.is_screen_count(1) then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                    return
                end

                local localScreen, tag
                local mapping = tagMapper[i]

                if mapping then
                    localScreen = screen[mapping.screen]
                    tag = localScreen.tags[mapping.tag]
                end

                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, {
            description = "move focused client to tag " .. tag_name,
            group = "tag",
        })
    )
end

return keys
