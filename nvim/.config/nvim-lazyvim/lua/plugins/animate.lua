return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 5, total = 100 },
          easing = "linear",
        },
        spamming = 10, -- threshold for spamming detection
        filter = function(buf)
          return vim.g.snacks_scroll ~= false
            and vim.b[buf].snacks_scroll ~= false
            and vim.bo[buf].buftype ~= "terminal"
        end,
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",

    opts = { -- Default  Range
      stiffness = 0.8, -- 0.6      [0, 1]
      trailing_stiffness = 0.5, -- 0.3      [0, 1]
      distance_stop_animating = 0.5, -- 0.1      > 0
    },
  },
}
