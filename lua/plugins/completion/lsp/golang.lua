local M = {}
local config = require "plugins.completion.lsp.config"

M.config = {
   cmd = { "gopls", "--remote=auto" },
   on_attach = config.lsp_on_attach,
   on_init = config.lsp_on_init,
   capabilities = config.capabilities,
   init_options = { usePlaceholders = true, completeUnimported = true },
   setting = {
      gopls = {
         odelenses = {
            references = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            generate = true,
         },
         gofumpt = true,
      },
   },
}

return M
