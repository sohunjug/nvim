local M = {}

M.setup = function()
   local present, nls = pcall(require, "null-ls")
   if not present then
      vim.cmd [[packadd null-ls.nvim]]
      nls = require "null-ls"
   end
   local nls_utils = require "null-ls.utils"

   local b = nls.builtins

   nls.setup {
      debounce = 150,
      notify_format = "[null-ls] %s",
      update_in_insert = true,
      root_dir = nls_utils.root_pattern ".git",
      sources = {
         -- diagnostics
         b.diagnostics.eslint_d,
         b.diagnostics.ansiblelint,
         b.diagnostics.buf,
         b.diagnostics.checkmake,
         b.diagnostics.cppcheck,
         b.diagnostics.deadnix,
         -- b.diagnostics.djlint,
         b.diagnostics.editorconfig_checker.with {
            command = "editorconfig-checker",
         },
         b.diagnostics.fish,
         b.diagnostics.flake8,
         -- b.diagnostics.gccdiag,
         b.diagnostics.golangci_lint,
         b.diagnostics.hadolint,
         b.diagnostics.protoc_gen_lint,
         b.diagnostics.pyproject_flake8,
         b.diagnostics.shellcheck.with {
            diagnostics_format = "[#{c}] #{m} (#{s})",
         },
         b.diagnostics.statix,
         b.diagnostics.zsh,

         -- formatting
         b.formatting.stylua.with {
            extra_args = {
               "--config-path",
               vim.fn.stdpath "config" .. "/.stylua.toml",
               -- "-",
            },
         },
         -- b.formatting.nixfmt,
         -- b.formatting.yapf,
         b.formatting.black,
         b.formatting.buf,
         b.formatting.protolint,
         b.formatting.clang_format,
         b.formatting.cmake_format,
         -- b.formatting.fish_indent,
         b.formatting.gofumpt,
         b.formatting.goimports,
         b.formatting.jq,
         b.formatting.nginx_beautifier,
         b.formatting.rustfmt,
         b.formatting.sql_formatter,
         b.formatting.taplo,
         b.formatting.shfmt.with {
            extra_args = { "-i", "2", "-ci" },
         },
         b.formatting.beautysh,
         b.formatting.prettier_d_slim.with {
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
         -- completion
         b.completion.spell,

         -- code actions
         b.code_actions.gitsigns,
         b.code_actions.gitrebase,
         b.code_actions.eslint_d,
         b.code_actions.proselint,
         b.code_actions.statix,

         -- hover
         b.hover.dictionary,
      },
   }
   -- require("custom.lsp.format").lsp_before_save()
end

return M
