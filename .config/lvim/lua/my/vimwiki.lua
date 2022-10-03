local notes_dir = '~/Dropbox/Notes'

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

local notes_dirs_pat = table.concat({ notes_dir .. '/*' }, ',')

table.insert(lvim.plugins, {
  "vimwiki/vimwiki",
  event = 'BufEnter ' .. notes_dirs_pat,
})