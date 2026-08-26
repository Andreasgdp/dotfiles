return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic", -- or "off" to reduce noise
                diagnosticSeverityOverrides = {
                  reportCallIssue = "none", -- Disable this specific diagnostic
                  reportGeneralTypeIssues = "none", -- Optional: if Django's dynamicism causes other errors
                },
              },
            },
          },
        },
        copilot = {},
      },
      inlay_hints = {
        enabled = true,
        exclude = { "vue", "java" }, -- filetypes for which you don't want to enable inlay hints
      },
    },
  },
}
