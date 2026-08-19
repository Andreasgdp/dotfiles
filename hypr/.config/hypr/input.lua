hl.config({
  input = {
    -- Keyboard layout and repeat speed
    kb_variant = "altgr-intl",
    kb_options = "compose:caps",
    repeat_rate = 40,
    repeat_delay = 600,
    numlock_by_default = true,

    -- Pointer and touchpad sensitivity (faster)
    sensitivity = 0.45,

    touchpad = {
      natural_scroll = false,
      clickfinger_behavior = true,
      scroll_factor = 0.4,
      disable_while_typing = false,
      drag_3fg = 1,
    },

    scroll_factor = 1,
  },
})

-- App-specific touchpad scroll speeds
o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
