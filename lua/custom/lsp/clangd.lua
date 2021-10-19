local M = {}
local config = require "custom.lsp.config"
local util = require "lspconfig.util"

if vim.fn.executable "/opt/homebrew/opt/llvm/bin/clangd" == 1 then
   M.cmd = "/opt/homebrew/opt/llvm/bin/clangd"
elseif vim.fn.executable "/usr/bin/clangd" == 1 then
   M.cmd = "/usr/bin/clangd"
else
   M.cmd = "gopls"
end

M.config = {
   cmd = { M.cmd, "--background-index", "--suggest-missing-includes", "--clang-tidy", "--header-insertion=iwyu" },
   on_attach = config.lsp_on_attach,
   on_init = config.lsp_on_init,
   capabilities = config.capabilities,
   filetypes = { "c", "cpp", "objc", "objcpp" },
   root_dir = util.root_pattern("build/compile_commands.json", "compile_commands.json", "compile_flags.txt", ".git"),
}

return M
