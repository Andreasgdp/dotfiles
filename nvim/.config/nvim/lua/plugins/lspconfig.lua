return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {},
      },
      inlay_hints = {
        enabled = true,
        exclude = { "vue", "java" }, -- filetypes for which you don't want to enable inlay hints
      },
    },
  },
}
