return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      cs = { "csharpier" },
      -- java = { "google-java-format" },
      java = { "nothing" },
    },
    formatters = {
      csharpier = {
        command = "dotnet format",
      },

      nothing = {
        -- don't have a good formatting setup for java, so better to do nothing than mess things up
        command = "true",
      },
      -- ["google-java-format"] = {
      --   command = "google-java-format",
      --   args = { "--aosp", "-" },
      -- },
    },
  },
}
