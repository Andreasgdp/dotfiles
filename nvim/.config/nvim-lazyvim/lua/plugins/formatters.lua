return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      cs = { "csharpier" },
      java = { "google-java-format" },
    },
    formatters = {
      csharpier = {
        command = "dotnet format",
      },
      ["google-java-format"] = {
        command = "google-java-format",
        args = { "--aosp", "-" },
      },
    },
  },
}
