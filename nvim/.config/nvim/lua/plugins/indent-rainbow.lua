return {
  "lukas-reineke/indent-blankline.nvim",
  event = "LazyFile",
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        "help",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
  main = "ibl",
  config = function()
    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }

    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#9B4D55" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#A5774C" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#475976" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#9D855F" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#6C7E5F" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#7E616D" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#566F7F" })
    end)

    require("ibl").setup({ indent = { highlight = highlight } })
  end,
}
