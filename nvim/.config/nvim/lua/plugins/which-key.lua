-- which-key helps you remember key bindings by showing a popup
-- with the active keybindings of the command you started typing.
return {
  "folke/which-key.nvim",
  opts = {
    defaults = {
      ["<leader>gb"] = { name = "+buffer" },
    },
  },
}
