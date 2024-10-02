return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "eslint-lsp", -- javascript
      "prettier", -- javascript
      "tailwindcss-language-server", -- tailwindcss
      "typescript-language-server", -- typescript
      "angular-language-server", -- angular
      "sonarlint-language-server", -- sonarlint
      "stylua", -- lua
      "lua-language-server", -- lua
      "markdown-toc", -- markdown
      "markdownlint-cli2", -- markdown
      "shellcheck", -- shell
      "shfmt", -- shell
      "hadolint", -- docker
      "tflint", -- terraform
      "omnisharp", -- csharp
      "jdtls", -- java
    },
  },
}
