local M = {}
local config = require "custom.lsp.config"

if vim.fn.executable(S_NVIM.home .. "/.asdf/installs/golang/package/bin/gopls") == 1 then
   M.cmd = S_NVIM.home .. "/.asdf/installs/golang/package/bin/gopls"
elseif vim.fn.executable(S_NVIM.home .. "/.asdf/shims/gopls") == 1 then
   M.cmd = S_NVIM.home .. "/.asdf/shims/gopls"
else
   M.cmd = "gopls"
end

M.config = {
   cmd = { M.cmd, "--remote=auto" },
   on_attach = config.lsp_on_attach,
   on_init = config.lsp_on_init,
   capabilities = config.capabilities,
   init_options = { usePlaceholders = true, completeUnimported = true },
   setting = {
      gopls = {
         analyses = {
            unusedparams = true,
         },
         staticcheck = true,
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
