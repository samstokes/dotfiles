local vault = "~/Notes"
local vault_expanded = vim.fn.expand(vault)

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  -- only load obsidian.nvim for markdown files in the vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    "BufReadPre "
      .. vault_expanded
      .. "/*.md",
    "BufNewFile " .. vault_expanded .. "/*.md",
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "work",
        path = vault,
      },
    },

    daily_notes = {
      folder = "diary",
    },
  },

  keys = {
    { "<Leader>o", "<CMD>Obsidian<CR>", desc = "Obsidian" },
  },
}
