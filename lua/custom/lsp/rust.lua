local M = {}
local config = require "custom.lsp.config"

M.config = {
   on_attach = config.lsp_on_attach,
   on_init = config.lsp_on_init,
   -- capabilities = config.capabilities,
}

M.setup = function()
   local present, rust_tools = pcall(require, "rust-tools")
   if not present then
      vim.cmd [[packadd rust-tools.nvim]]
      rust_tools = require "rust-tools"
   end

   rust_tools.setup { server = M.config }
end

return M
