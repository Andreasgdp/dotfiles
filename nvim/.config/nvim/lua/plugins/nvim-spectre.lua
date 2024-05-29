return {
  "nvim-pack/nvim-spectre",
  build = false,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  -- stylua: ignore
  keys = {
    { "<leader>S", function() require("spectre").toggle() end, desc = "Toggle Replace (spectre)" },
    { "<leader>sR", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    { "<leader>sr", function() require("spectre").open_file_search({select_word=true}) end, desc = "Search on current file" , remap = true },
  },
}
