return {
  "ThePrimeagen/git-worktree.nvim",
  config = function()
    require("git-worktree").setup()

    vim.keymap.set("n", "<leader>gw", ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", {})
    vim.keymap.set(
      "n",
      "<leader>gwc",
      ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
      {}
    )
  end,
}
