return { -- add any tools you want to have installed below
  "mason-org/mason.nvim",
  opts = {
    registries = {
      "github:mason-org/mason-registry",
      "github:Crashdummyy/mason-registry",
    },
    ensure_installed = {
      "roslyn", -- C# language server
      "copilot-language-server",
    },
  },
}
