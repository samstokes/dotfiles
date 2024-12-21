local marksman = require('lspconfig').marksman
if marksman then
  marksman.setup({
    filetypes = { 'markdown', 'vimwiki' },
    on_attach = function(client, bufnr)
      require('lvim.lsp').common_on_attach(client, bufnr)
    end,
  })
end
