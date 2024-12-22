---@type LazySpec
return {
  -- as https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/plugins/neo-tree.lua
  -- but disable git_status source because it blows up
  -- and disable buffers source because it's also surprisingly slow and leaky
  -- and disable hiding dotfiles
  -- TODO both only in home directory
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, config)
      config.filesystem.filtered_items.hide_dotfiles = false
      config.sources = { "filesystem" }
    end,
  },
}
