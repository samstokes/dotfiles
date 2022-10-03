-- see https://github.com/scalameta/nvim-metals#user-content-fn-shortmess-7339b78fb5b06c569d620f975212382f
vim.opt_global.shortmess:remove("F")

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach({
      showImplicitArguments = true,
    })
  end,
  group = nvim_metals_group,
})
