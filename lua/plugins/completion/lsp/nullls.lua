local M = {}

M.setup = function()
   local null_ls = require "null-ls"
   local b = null_ls.builtins

   null_ls.config {
      debounce = 150,
      sources = {
         b.diagnostics.eslint.with {
            command = "eslint_d",
         },
         b.formatting.stylua.with {
            args = {
               "--config-path",
               vim.fn.stdpath "config" .. "/.stylua.toml",
               "-",
            },
         },
         b.formatting.shfmt.with {
            extra_args = { "-i", "2", "-ci" },
         },
         b.formatting.prettierd.with {
            filetypes = {
               "typescriptreact",
               "typescript",
               "javascriptreact",
               "javascript",
               "svelte",
               "json",
               "jsonc",
               "css",
               "yaml",
               "markdown",
               "html",
            },
         },
      },
   }
end

return M
