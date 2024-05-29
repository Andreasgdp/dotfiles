return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true })
      end,
      { desc = "Explorer NeoTree current file (Root Dir)", remap = true },
    },
  },
  opts = {
    window = {
      close_if_last_window = true,
      position = "current",
      width = 60,
    },
    event_handlers = {
      {
        event = "file_opened",
        ---@diagnostic disable-next-line: unused-local
        handler = function(file_path)
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
    },
    hijack_netrw_behavior = "open_current",
    filesystem = {
      filtered_items = {
        visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
        hide_dotfiles = false,
        hide_gitignored = true,
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
    },
  },
}
