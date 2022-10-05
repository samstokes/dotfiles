local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    -- see https://github.com/scalameta/nvim-metals#user-content-fn-shortmess-7339b78fb5b06c569d620f975212382f
    vim.opt_global.shortmess:remove("F")

    local metals = require('metals')

    local metals_config = metals.bare_config()
    metals_config.on_attach = function(client, bufnr)
      require("lvim.lsp").common_on_attach(client, bufnr)
      -- TODO maybe bind this to metals.run_scalafix
      -- local wk = require("which-key")
      -- wk.register({ ["go"] = { "<cmd>lua require('metals').organize_imports()<CR>", "Organize Imports" } },
      --   { mode = "n", buffer = bufnr })

      -- TODO maybe centralize this?
      require("metals").setup_dap()
    end
    metals_config.settings = {
      showImplicitArguments = true,
      showInferredType = true,
    }

    lvim.builtin.lualine.sections.lualine_y = { 'g:metals_status' }
    require('lualine').setup(lvim.builtin.lualine)
    metals_config.init_options.statusBarProvider = 'on'

    metals.initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
