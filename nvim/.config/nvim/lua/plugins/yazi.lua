---@module "lazy"
---@module "yazi"

---@type LazySpec
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        -- Open in the current working directory
        "<leader>E",
        function()
          require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        desc = "Open the file manager in nvim's working directory",
      },
      {
        -- open yazi with current file selected i.e. supply path to current file
        "<leader>e",
        function()
          require("yazi").yazi(nil, vim.fn.findfile(vim.fn.expand("%:p"), ";"))
        end,
        desc = "Open the file manager in the current file's directory",
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
    },
  },
}
