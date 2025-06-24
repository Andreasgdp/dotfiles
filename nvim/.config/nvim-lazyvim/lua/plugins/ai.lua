---@module "lazy"

---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-J>",
          accept_word = false,
          accept_line = false,
          next = "<C-L>",
          prev = "<C-H>",
          dismiss = "<C-;>",
        },
      },
      filetypes = { ["*"] = true },
      copilot_node_command = "node", -- Node.js version must be > 18.x
      server_opts_overrides = {},
    },
  },
}
