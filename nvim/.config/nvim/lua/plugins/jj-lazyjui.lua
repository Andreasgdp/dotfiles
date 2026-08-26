return {
  "mrdwarf7/lazyjui.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<Leader>gj",
      function()
        require("lazyjui").open()
      end,
    },
  },
  ---@type lazyjui.Opts
  opts = {
    border = {
      chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      thickness = 1,
      winhl_str = "FloatBorder:LazyJuiBorder,NormalFloat:LazyJuiFloat",
    },
    cmd = { "jjui" },
    height = 0.8,
    width = 0.9,
    winblend = 0,
    use_default_keymaps = true,
  },
}
