local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    -- based on https://github.com/LunarVim/LunarVim/issues/2121#issuecomment-1199926585

    -- see https://github.com/scalameta/nvim-metals#user-content-fn-shortmess-7339b78fb5b06c569d620f975212382f
    vim.opt_global.shortmess:remove("F")

    local metals = require('metals')

    local metals_config = metals.bare_config()
    metals_config.on_attach = function(client, bufnr)
      require("lvim.lsp").common_on_attach(client, bufnr)

      local wk = require("which-key")
      wk.register({
        m = {
          name = "+Metals",
          f = { function() require('metals').run_scalafix() end, "Organize Imports" },
          v = { function() require('metals.tvp').reveal_in_tree() end, "Reveal in Tree" },
          t = { function() require('metals.tvp').toggle_tree_view() end, "Toggle Tree View" },
          K = { function() require('metals').hover_worksheet() end, "Show full result in worksheet" },
        },
      }, lvim.builtin.which_key.opts)

      -- TODO maybe centralize this?
      require("metals").setup_dap()
    end
    metals_config.settings = {
      showImplicitArguments = true,
      showImplicitConversionsAndClasses = true,
      showInferredType = true,
      superMethodLensesEnabled = true,
    }

    lvim.builtin.lualine.sections.lualine_y = { 'g:metals_status' }
    require('lualine').setup(lvim.builtin.lualine)
    metals_config.init_options.statusBarProvider = 'on'

    metals.initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
