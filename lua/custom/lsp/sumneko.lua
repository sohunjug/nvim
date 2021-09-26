-- local sumneko_root = os.getenv "HOME" .. "/Repos/lua-language-server"
local M = {}
local config = require "custom.lsp.config"

M.argv = S_NVIM.vim_path .. "/lsp/lua-language-server/main.lua"
M.enable = false
if vim.fn.executable(S_NVIM.vim_path .. "/lsp/lua-language-server/bin/macOS/lua-language-server") == 1 then
   M.enable = true
   M.cmd = S_NVIM.vim_path .. "/lsp/lua-language-server/bin/macOS/lua-language-server"
elseif vim.fn.executable(S_NVIM.vim_path .. "/lsp/lua-language-server/bin/linux/lua-language-server") == 1 then
   M.enable = true
   M.cmd = S_NVIM.vim_path .. "/lsp/lua-language-server/bin/linux/lua-language-server"
end

M.config = {
   cmd = {
      M.cmd,
      "-E",
      M.argv,
   },
   on_attach = config.lsp_on_attach,
   on_init = config.lsp_on_init,
   settings = {
      Lua = {
         completion = {
            enable = true,
            callSnippet = "Replace",
         },
         runtime = {
            version = "LuaJIT",
            path = (function()
               local runtime_path = vim.split(package.path, ";")
               table.insert(runtime_path, "lua/?.lua")
               table.insert(runtime_path, "lua/?/init.lua")
               table.insert(runtime_path, S_NVIM.data_dir .. "pack/packer/opt/*/?.lua")
               table.insert(runtime_path, S_NVIM.data_dir .. "pack/packer/start/*/?.lua")
               table.insert(runtime_path, S_NVIM.vim_path .. "/lua/?.lua")
               -- table.insert(runtime_path, S_NVIM.data_dir .. "pack/packer/opt/packer.nvim/lua/?.lua")
               -- table.insert(runtime_path, S_NVIM.data_dir .. "pack/packer/opt/packer.nvim/lua/packer/?.lua")
               if
                  S_NVIM.is_mac
                  and vim.fn.filereadable "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/doc/init.lua"
               then
                  table.insert(runtime_path, "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/?/?.lua")
                  table.insert(runtime_path, "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/?/?/?.lua")
               end
               return runtime_path
            end)(),
         },
         diagnostics = {
            enable = true,
            globals = {
               "vim",
               "packer_plugins",
               "describe",
               "it",
               "before_each",
               "after_each",
               "awesome",
               "theme",
               "client",
               "P",
               "hs",
               "spoon",
               "S_NVIM",
               "S_HS_CONFIG",
            },
         },
         workspace = {
            -- library = vim.list_extend({[vim.fn.expand("$VIMRUNTIME/lua")] = true}, {}),
            library = {
               [vim.fn.expand "$VIMRUNTIME/lua"] = true,
               [S_NVIM.vim_path .. "/lua"] = true,
               [S_NVIM.data_dir .. "/pack/packer/opt/packer.nvim/lua"] = true,
               [vim.fn.expand "$VIMRUNTIME/vim/lsp"] = true,
               -- [S_NVIM.vim_path .. "/lsp/lua-language-server/lua"] = true
               ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/?/?.lua"] = true,
               ["/opt/homebrew/share/luajit-2.1.0-beta3/jit"] = true,
            },
            checkThirdParty = true,
            maxPreload = 10000,
            preloadFileSize = 5000,
         },
      },
   },
}

M.config.capabilities = vim.lsp.protocol.make_client_capabilities()
M.config.capabilities.textDocument.semanticTokens = {}
M.config.capabilities.textDocument.semanticTokens.dynamicRegistration = false

return M
