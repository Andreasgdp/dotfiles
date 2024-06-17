-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

function feedkeys(key, mode)
  local keys = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(keys, mode, true)
end

-- When opening the first and only the first file, run :Gitsigns toggle_current_line_blame<CR>
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  once = true,
  callback = function()
    vim.defer_fn(function()
      vim.cmd("Gitsigns toggle_current_line_blame")
    end, 100)
  end,
})

-- when entering insert mode, trigger copilot to generate a suggestion
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      if not require("copilot.client").is_disabled() then
        -- TODO: Check in once in a while if this is still needed
        -- insert a space and remove it again to trigger cpilot
        -- this is a workaround for the issue that cpilot does not trigger on the first character
        feedkeys("<space><BS>", "n")
      end
    end, 100)
  end,
})

-- The following is for debugging copilot status
-- Use it in the bottom of e.g. lua/config/keymaps.lua as there the copilot client is already loaded
-- require('copilot.api').register_status_notification_handler(function(data)
--   print("Copilot Status: " .. data.status)
-- end)
