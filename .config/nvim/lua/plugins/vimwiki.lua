local notes_dir = "/home/sam/Dropbox/Notes"

if vim.fn.isdirectory(notes_dir) then
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

local notes_dirs_pat = notes_dir .. "/*"

vim.treesitter.language.register("markdown", "vimwiki")

return {
  {
    "vimwiki/vimwiki",
    event = "BufEnter " .. notes_dirs_pat,
    config = function()
      vim.o.iskeyword = vim.o.iskeyword .. ",-"
    end,
  },
  { "samstokes/vim-notes" },
  -- Configure Marksman to work for vimwiki filetype too
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          filetypes = { "markdown", "vimwiki" },
        },
      },
    },
  },
  -- Disable Copilot for vimwiki (don't send my notes to the cloud)
  {
    "zbirenbaum/copilot.lua",
    optional = true, -- don't actually install copilot.lua unless it's installed elsewhere
    opts = { filetypes = { vimwiki = false } },
  },
}
