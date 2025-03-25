return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", "/home/anpe/.markdownlint-cli2.yaml", "--" },
      },
    },
  },
}
