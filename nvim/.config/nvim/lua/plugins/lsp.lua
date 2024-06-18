-- TODO: Add basic LSP support and ensure languages I use have LSP support.
-- Basically it is only to ensure lsp and mason have the language servers installed
-- The rest is handled by the setup provided by LazyVim
return {
  -- TODO: test this csharp plugin out and see how it fares together with the current csharp setup.
  -- If it deoes not work well, remove it.
  "iabdelkareem/csharp.nvim",
  dependencies = {
    "williamboman/mason.nvim", -- Required, automatically installs omnisharp
    "mfussenegger/nvim-dap",
    "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
  },
  config = function()
    require("mason").setup() -- Mason setup must run before csharp
    require("csharp").setup()
  end,
}
