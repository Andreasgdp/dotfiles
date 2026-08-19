local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Default fallback for laptop internal display and other monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Desktop monitor setup
hl.monitor({ output = "DP-1", mode = "2560x1440@75", position = "0x0", scale = 1.25 })
hl.monitor({ output = "DP-2", mode = "2560x1440@165.00", position = "2048x0", scale = 1.25 })
hl.monitor({ output = "DP-3", mode = "2560x1440@75", position = "4096x0", scale = 1.25 })
