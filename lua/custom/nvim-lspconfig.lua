local M = {
   opt = true,
   requires = {
      "onsails/lspkind-nvim",
      "simrat39/rust-tools.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      {
         "jose-elias-alvarez/nvim-lsp-ts-utils",
         ft = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
         },
      },
   },
   ft = {
      "markdown",
      "javascript",
      "go",
      "c",
      "cpp",
      "shell",
      "vim",
      "dockerfile",
      "dot",
      "vue",
      "css",
      "nix",
      "python",
      "json",
      "yaml",
      "graphql",
      "rust",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "lua",
   },
}

M.config = function()
   require("custom.lsp").setup()
end
--[[ M.setup = function()
   require("core.utils").packer_lazy_load "nvim-lspconfig"
   -- reload the current file so lsp actually starts for it
   vim.defer_fn(function()
      vim.cmd "silent! e %"
   end, 0)
end ]]
return M
