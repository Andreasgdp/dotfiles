return {
  "levouh/tint.nvim",
  event = "VeryLazy",
  config = function()
    require("tint").setup()

    vim.api.nvim_create_autocmd("FocusLost", {
      callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          require("tint").tint(win)
        end
      end,
    })

    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function()
        local current = vim.api.nvim_get_current_win()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if win == current then
            require("tint").untint(win)
          else
            require("tint").tint(win)
          end
        end
      end,
    })
  end,
}
