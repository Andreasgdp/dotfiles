return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {
      enabled = true,
    },
    picker = {
      sources = {
        files = {
          hidden = true,
        },
        explorer = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
      },
    },
  },
}
