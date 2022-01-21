local M = {}

M.setup = function()
   local present, null_ls = pcall(require, "null-ls")
   if not present then
      vim.cmd [[packadd null-ls.nvim]]
      null_ls = require "null-ls"
   end

   local b = null_ls.builtins

   null_ls.setup {
      -- debounce = 150,
      sources = {
         b.diagnostics.eslint.with {
            command = "eslint_d",
         },
         b.formatting.stylua.with {
            extra_args = {
               "--config-path",
               vim.fn.stdpath "config" .. "/.stylua.toml",
               -- "-",
            },
         },
         b.formatting.nixfmt,
         -- b.formatting.yapf,
         -- b.formatting.clang_format,
         b.formatting.black,
         -- b.formatting.goimports,
         b.formatting.shfmt.with {
            extra_args = { "-i", "2", "-ci" },
         },
         b.formatting.prettier.with {
            filetypes = {
               "typescriptreact",
               "typescript",
               "javascriptreact",
               "javascript",
               "svelte",
               -- "json",
               -- "jsonc",
               "css",
               "scss",
               "vue",
               "yaml",
               "markdown",
               "html",
            },
         },
      },
   }
end

return M
