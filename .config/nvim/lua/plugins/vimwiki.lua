local notes_dir = "/home/sam/Dropbox/Notes"

if vim.fn.glob(notes_dir) ~= "" then
  vim.g.vimwiki_list = {
    {
      path = notes_dir,
      auto_tags = 1,
      syntax = "markdown",
      ext = ".md",
    },
  }
end

-- Make vimwiki recognize tags in frontmatter, compatible with Obsidian and Jekyll.
-- Disables default :tag:list: format and ability to write #tags inline.
vim.g.vimwiki_tag_format = {
  pre = "\\(^tags:\\s*\\)",
  pre_mark = "",
  ["in"] = "\\k\\+",
  sep = "[[:space:]]\\+",
  post_mark = "",
  post = "",
}

vim.treesitter.language.register("markdown", "vimwiki")

local notes_dirs_pat = notes_dir .. "/*"

---@type LazySpec
local packages = {
  {
    "vimwiki/vimwiki",
    event = "BufEnter " .. notes_dirs_pat,
    config = function() vim.o.iskeyword = vim.o.iskeyword .. ",-" end,
    -- override AstroCore rooter
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          ---@type AstroCoreOpts
          local astrocore_opts = opts
          table.insert(astrocore_opts.rooter.detector, { ".vimwiki_tags" })
        end,
      },
    },
  },
  { "samstokes/vim-notes" },
}

return packages
