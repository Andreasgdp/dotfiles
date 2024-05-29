-- TODO: setup keymaps https://github.com/ThePrimeagen/refactoring.nvim
return {
  -- Incremental rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>rn",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        desc = "Incremental rename",
        mode = "n",
        remap = true,
        expr = true,
      },
    },
    config = true,
  },
  -- Refactoring tool
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor({
            show_success_message = true,
          })
        end,
        mode = "v",
        remap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },
}
