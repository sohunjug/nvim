local M = {
   opt = true,
   cmd = "LspInstall",
   --[[ setup = function()
      require("core.utils").packer_lazy_load "nvim-lspinstall"
      -- reload the current file so lsp actually starts for it
      vim.defer_fn(function()
         vim.cmd "silent! e %"
      end, 0)
   end, ]]
}

return M
