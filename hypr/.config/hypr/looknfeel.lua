hl.config({
  dwindle = {
    precise_mouse_move = true,
  },
  misc = {
    mouse_move_focuses_monitor = false,
  },
})

-- App workspace assignments and rules
o.window("chrome-web\\.akiflow\\.com__-Default", { workspace = "1" })
o.window("chrome-www\\.facebook\\.com__messages_e2ee_t-Default", { workspace = "3" })
o.window("chrome-app\\.shortwave\\.com__-Default", { workspace = "10" })
o.window("chrome-discord\\.com__channels_@me-Default", { workspace = "3" })
o.window("slack", { workspace = "3" })
o.window("(Alacritty|kitty|com\\.mitchellh\\.ghostty)", { workspace = "4" })
o.window("zen", { workspace = "2" })
o.window("Spotify", { workspace = "6" })
o.window("obsidian", { workspace = "7" })
o.window("steam", { workspace = "8" })
o.window("steam_app.*", { tile = true, monitor = "DP-2", workspace = "8", fullscreen = true })
