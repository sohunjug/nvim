local M = {
   opt = true,
}

M.setup = function()
   vim.env.PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath "config" .. "/.prettierrc"
require("core.utils").packer_lazy_load "nvim-lspconfig"
   -- reload the current file so lsp actually starts for it
   vim.defer_fn(function()
      vim.cmd "silent! e %"
   end, 0)

end

M.config = function()
   require("custom.lsp.nullls").setup()

end

return M
