-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.
return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = { options = vim.opt.sessionoptions:get() },
  keys = {
    {
      "<leader>qs",
      function()
        -- due to bug with Gitsigns not showing up after restoring
        -- session with Neotree open we close it before saving the session
        vim.cmd("Neotree close")
        -- wait for the tree to close before saving the session
        vim.defer_fn(function()
          require("persistence").load()
        end, 100)
      end,
      desc = "Restore Session",
    },
    {
      "<leader>ql",
      function()
        vim.cmd("Neotree close")
        vim.defer_fn(function()
          require("persistence").load({ last = true })
        end, 100)
      end,
      desc = "Restore Last Session",
    },
    {
      "<leader>qd",
      function()
        require("persistence").stop()
      end,
      desc = "Don't Save Current Session",
    },
  },
}
