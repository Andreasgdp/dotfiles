return {
  "tummetott/reticle.nvim",
  event = "VeryLazy", -- optionally lazy load the plugin
  config = function()
    require("reticle").setup({
      on_startup = {
        cursorline = true,
        cursorcolumn = true,
      },
    })
    -- Set color explicitly by defining a RGB value
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2A2B3C" })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#2A2B3C" })
  end,
}
