local notes_dir = '/home/sam/Dropbox/Notes'

---@diagnostic disable-next-line:missing-parameter
if vim.fn.glob(notes_dir) ~= "" then
  vim.g.vimwiki_list = {
    {
      path = notes_dir,
      auto_tags = 1,
      syntax = 'markdown',
      ext = '.md',
    },
  }
end

-- Make vimwiki recognize tags in frontmatter, compatible with Obsidian and Jekyll.
-- Disables default :tag:list: format and ability to write #tags inline.
vim.g.vimwiki_tag_format = {
  pre = '\\(^tags:\\s*\\)',
  pre_mark = '',
  ['in'] = '\\k\\+',
  sep = '[[:space:]]\\+',
  post_mark = '',
  post = '',
}

local notes_dirs_pat = notes_dir .. '/*'

table.insert(lvim.plugins, {
  "vimwiki/vimwiki",
  event = 'BufEnter ' .. notes_dirs_pat,
  config = function()
    vim.o.iskeyword = vim.o.iskeyword .. ',-'
  end
})
table.insert(lvim.plugins, { "samstokes/vim-notes" })

table.insert(lvim.builtin.project.patterns, 1, '.vimwiki_tags')

vim.treesitter.language.register('markdown', 'vimwiki')
